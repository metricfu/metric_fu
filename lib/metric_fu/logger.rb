require "logger"
require "forwardable"
module MetricFu
  def self.logger
    @logger ||= ::MetricFu::Logger.new($stdout)
  end

  class Logger
    extend Forwardable
    MfLogger = ::Logger

    def initialize(stdout)
      @logger = MfLogger.new(stdout)
      self.debug_on = false
      self.formatter = ->(_severity, _time, _progname, msg) { "#{msg}\n" }
      self.level = "info"
    end

    def debug_on=(bool)
      self.level = bool ? "debug" : "info"
    end

    def debug_on
      @logger.level == MfLogger::DEBUG
    end

    def_delegators :@logger, :info, :warn, :error, :fatal, :unknown

    LEVELS = {
      "debug" => MfLogger::DEBUG,
      "info"  => MfLogger::INFO,
      "warn"  => MfLogger::WARN,
      "error" => MfLogger::ERROR,
      "fatal" => MfLogger::FATAL,
      "unknown" => MfLogger::UNKNOWN,
    }

    def level=(level)
      @logger.level = LEVELS.fetch(level.to_s.downcase) { level }
    end

    def formatter=(formatter)
      @logger.formatter = formatter
    end

    def log(msg)
      @logger.info "*" * 5 + msg.to_s
    end

    def debug(msg)
      @logger.debug "*" * 5 + msg.to_s
    end
  end
end
# For backward compatibility
def mf_debug(msg, &block)
  MetricFu.logger.debug(msg, &block)
end

def mf_log(msg, &block)
  MetricFu.logger.log(msg, &block)
end
