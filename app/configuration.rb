require 'yaml'

class Configuration
  class << self 
    def amazon_s3_key_id
      configuration["amazon_s3_key_id"]
    end

    def amazon_s3_secret_access_key
      configuration["amazon_s3_secret_access_key"]
    end

    def rackspace_user_id
      configuration["rackspace_user_id"]
    end

    def rackspace_key
      configuration["rackspace_key"]
    end

    private
    def configuration
      YAML.load_file(Dir.pwd + '/config/config.yaml')
    end
  end
end
