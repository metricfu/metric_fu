# rake is required for
# Saikuro : sh
# Rcov    : FileList
# loading metric_fu.rake
require 'rake'

require 'yaml'
require 'redcard'

MetricFu.configure
MetricFu.logging_require { 'mf_debugger' }
include MfDebugger
MfDebugger::Logger.debug_on = !!(ENV['MF_DEBUG'] =~ /true/i)
