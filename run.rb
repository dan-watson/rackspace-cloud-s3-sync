require File.join(File.dirname(__FILE__), "app")
RackSpaceCloudS3Sync.new(:ignore_buckets => %w(.CDN_ACCESS_LOGS au dnai document media_files_development missing screenshots video)).build
