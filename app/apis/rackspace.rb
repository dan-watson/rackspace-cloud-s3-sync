require 'cloudfiles'
require 'mime/types'

class Rackspace
  def initialize
    @rackspace_connection = CloudFiles::Connection.new(:username => Configuration.rackspace_user_id, :api_key => Configuration.rackspace_key)
    @rackspace_storage_host = @rackspace_connection.storagehost
  end

  def containers
    @rackspace_connection.containers
  end

  def container name
    { 
      :base_url => @rackspace_connection.container(name).cdn_url || "http://#{@rackspace_storage_host}/#{name}", 
      :objects => @rackspace_connection.container(name).objects 
    }
  end

  def build_item_uri host_url, name
    "#{host_url}/#{name}" 
  end

  def item_content_type item
    MIME::Types.type_for(item)[0] || 'application/octet-stream'
  end
end
