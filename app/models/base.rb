require 'rubygems'
require 'sequel'
require 'logger'

module Sequel
  class Model
    Sequel::Model.db = Sequel.connect("sqlite:///#{File.dirname(__FILE__)}/../../db/rackspace-cloud-s3.db")

    def before_create
      self.created_at ||= Time.now
      super
    end

    def before_update
      self.updated_at ||= Time.now
      super
    end
  end
end
