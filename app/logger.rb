require 'logger'
require 'singleton'

class Log
  include Singleton

  def error message
    logger.error message
  end

  def info message
    logger.info message
  end

  def fatal message
    logger.fatal message
  end

  private
  def logger
    @logger ||= Logger.new(Dir.pwd + "/logs/log.log")
  end
end

