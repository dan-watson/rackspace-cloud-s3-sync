require 'rubygems'
require 'aws/s3'
require 'cloudfiles'
require File.join(File.dirname(__FILE__), "app", "configuration")
require File.join(File.dirname(__FILE__), "app", "models", "sync")
require File.join(File.dirname(__FILE__), "app", "logger")


class RackSpaceCloudS3Sync
  def initialize
    @rackspace_connection = CloudFiles::Connection.new(:username => Configuration.rackspace_user_id, :api_key => Configuration.rackspace_key)
    @rackspace_storage_host = @rackspace_connection.storagehost
    AWS::S3::Base.establish_connection!(:access_key_id => Configuration.amazon_s3_key_id, :secret_access_key => Configuration.amazon_s3_secret_access_key)
  end

  def build_database_from_rackspace
     
  end

  def sync

  end

  def rackspace_containers
    @rackspace_connection.containers
  end

  def rackspace_container name
    @rackspace_connection.container(name).objects
  end

  def build_item_uri container, name
   "http://#{@rackspace_storage_host}/#{container}/#{name}" 
  end

  def item_content_type item
     
  end

end
