require 's3'

class AmazonS3
  def initialize
    @service = S3::Service.new(:access_key_id => Configuration.amazon_s3_key_id, 
                    :secret_access_key => Configuration.amazon_s3_secret_access_key)
  end

  def service
    @service
  end

  def upload bucket_prefix, bucket, file, region
    bucket = "#{bucket_prefix}#{bucket}"
    Log.instance.info "Uploading #{file} to #{bucket}"
    begin
      service.bucket(bucket).save(region.to_sym)
    rescue S3::Error::BucketAlreadyOwnedByYou
    end
    object = service.bucket(bucket).objects.build(file)
    object.content = open(File.dirname(__FILE__) + '/../../files/' + file)
    object.save
  end
end
