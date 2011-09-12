require 'fileutils'

module FileHelper
  def write_file(filename, data)
    file_path = File.dirname(__FILE__) + '/../../files/' + filename

    FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists?(File.dirname(file_path))
    file = File.new(file_path, 'wb')
    file.write(data)
    file.close
  end

  def delete_file(filename)
    FileUtils.rm_rf(File.dirname(__FILE__) + '/../../files/' + filename)
  end
end
