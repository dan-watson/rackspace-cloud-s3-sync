require 'logger'
require 'singleton'

class Log
  include Singleton

  def error message
    loggers.each{ |logger| logger.error message }
  end

  def info message
    loggers.each{ |logger| logger.info message }
  end

  def fatal message
    loggers.each{ |logger| logger.fatal message }
  end

  private
  def loggers
    @loggers = []
    @loggers << Logger.new(Dir.pwd + "/logs/log.log")
    @loggers << Logger.new(STDOUT)
  end
end

