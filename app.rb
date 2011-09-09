require 'rubygems'
require 'aws/s3'
require 'cloudfiles'
require File.join(File.dirname(__FILE__), "app", "configuration")
require File.join(File.dirname(__FILE__), "app", "models", "sync")


class RackSpaceCloudS3Sync
  def initialize
    @rackspace_connection = CloudFiles::Connection.new(:username => Configuration.rackspace_user_id, :api_key => Configuration.rackspace_key)
    AWS::S3::Base.establish_connection!(:access_key_id => Configuration.amazon_s3_key_id, :secret_access_key => Configuration.amazon_s3_secret_access_key)
  end

  def build_database_from_rackspace
    
  end

  def sync

  end

end
