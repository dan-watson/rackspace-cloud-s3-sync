require 'rubygems'
require 'typhoeus'
require File.join(File.dirname(__FILE__), "app", "configuration")
require File.join(File.dirname(__FILE__), "app", "models", "sync")
require File.join(File.dirname(__FILE__), "app", "logger")
require File.join(File.dirname(__FILE__), "app", "apis", "amazon_s3")
require File.join(File.dirname(__FILE__), "app", "apis", "rackspace")
require File.join(File.dirname(__FILE__), "app", "helpers", "file_helper")


class RackSpaceCloudS3Sync
  include FileHelper

  def initialize(opts = {})
    @amazon = AmazonS3.new
    @rackspace = Rackspace.new
    @hydra = Typhoeus::Hydra.new(:max_concurrency => (opts[:threads] || 20))
    @statuses = opts[:statuses] || 0
    @queue_number_of_items = opts[:queue_number_of_items] || 20
    @with_build_database = opts[:with_build_database] || false
    @bucket_prefix = opts[:bucket_prefix] || "dna-bucket-"
    @ignore_buckets = opts[:ignore_buckets] || []
    @region = opts[:region] || "eu"
  end

  def build
    begin
      build_database_from_rackspace if @with_build_database || Sync.count == 0
      Sync.limit(@queue_number_of_items).where(:status => @statuses).all.each do |item|
        queue item
      end
      @hydra.run
    rescue StandardError => bang
      Log.instance.error bang
    end
  end

  private
  def build_database_from_rackspace
    Log.instance.info "Started to sync rackspace file database"
    
    @rackspace.containers(:ignore_buckets => @ignore_buckets).each do |container|
      Log.instance.info "Starting to pull items for #{container}"
      container_hash = @rackspace.container(container)
      container_hash[:objects].each do |item|
        unless Sync.find(:bucket => container, :file_name => item)
          Sync.create(:bucket => container,
                      :file_name => item,
                      :file_extention => @rackspace.item_content_type(item),
                      :download_location => @rackspace.build_item_uri(container_hash[:base_url], item),
                      :status => 0) 
        end
      end
    end
  end

  def queue sync_item
   sync_item.in_progress!

   begin
     URI.parse(sync_item.download_location)
   rescue
     sync_item.failed!
     return
   end

   request = Typhoeus::Request.new(URI.encode(sync_item.download_location), :follow_location => true)

   request.on_complete do |response|
     if response.success?
       write_file(sync_item.file_name, response.body)
       success = @amazon.upload(@bucket_prefix, sync_item.bucket, sync_item.file_name, @region)
       if success
         sync_item.success!
         delete_file(sync_item.file_name)
       else
         sync_item.failed!
       end
     else
       sync_item.failed!
     end
   end
   @hydra.queue request
  end
end
