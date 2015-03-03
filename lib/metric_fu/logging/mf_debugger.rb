warn "MfDebugger if deprecated.  Please use MetricFu.logger"
MetricFu.lib_require { "logger" }
module MfDebugger
  extend self
  class Logger
    def self.debug_on
      warn "MfDebugger if deprecated.  Please use MetricFu.logger"
      MetricFu.logger.debug_on
    end
    def self.debug_on=(bool)
      warn "MfDebugger if deprecated.  Please use MetricFu.logger"
      MetricFu.logger.level = bool ? "debug" : "info"
    end
    def self.log(msg, &_block)
      warn "MfDebugger if deprecated.  Please use MetricFu.logger"
      MetricFu.logger.info msg
    end
    def self.debug(msg, &_block)
      warn "MfDebugger if deprecated.  Please use MetricFu.logger"
      MetricFu.logger.debug msg
    end
  end
end
