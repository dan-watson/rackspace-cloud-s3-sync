require 'cloudfiles'
require 'mime/types'

class Rackspace
  def initialize
    @rackspace_connection = CloudFiles::Connection.new(:username => Configuration.rackspace_user_id, :api_key => Configuration.rackspace_key)
    @rackspace_storage_host = @rackspace_connection.storagehost
  end

  def containers(opts = {})
    ignore_buckets = opts[:ignore_buckets] || []
    @rackspace_connection.containers.delete_if{|i| ignore_buckets.include?(i) }
  end

  def container name
    objects = []
    marker = nil

    while(true)
     holder = @rackspace_connection.container(name).objects(:limit => 10000, :marker => marker)
     objects << holder
     marker = holder.last
     break if holder.count < 10000
    end

    { 
      :base_url => @rackspace_connection.container(name).cdn_url || "http://#{@rackspace_storage_host}/#{name}", 
      :objects => objects.flatten.uniq
    }
  end

  def build_item_uri host_url, name
    "#{host_url}/#{name}" 
  end

  def item_content_type item
    MIME::Types.type_for(item)[0] || 'application/octet-stream'
  end
end
