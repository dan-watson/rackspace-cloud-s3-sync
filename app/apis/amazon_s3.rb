require 'aws/s3'

class AmazonS3
  def initialize
    AWS::S3::Base.establish_connection!(:access_key_id => Configuration.amazon_s3_key_id, :secret_access_key => Configuration.amazon_s3_secret_access_key)
  end

  def upload bucket_prefix, bucket, file
    bucket = "#{bucket_prefix}#{bucket}"
    Log.instance.info "Uploading #{file} to #{bucket}"
    AWS::S3::Bucket.create(bucket)
    response = AWS::S3::S3Object.store(file, open(File.dirname(__FILE__) + '/../../files/' + file), bucket, :access => :public_read)
    response.code == 200
  end
end
