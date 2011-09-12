require File.join(File.dirname(__FILE__), "base")

class Sync < Sequel::Model
  def pending!
    self.status = 0 
    save
  end

  def in_progress!
    Log.instance.info "Queued #{self.download_location}"
    self.status = 1
    save
  end

  def success!
    Log.instance.info "File uploaded to S3 - #{self.file_name}"
    self.status = 2
    save
  end

  def failed!
    Log.instance.error "File failed to uploaded to S3 - #{self.file_name}"
    self.status = 3
    save
  end
end
