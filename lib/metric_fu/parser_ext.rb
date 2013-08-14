# For Flog
# TODO: Do we still need this?
class RubyParser
  alias_method :original_process, :process
  def process(s,f,t)
    original_process(s,f,t)
  rescue => e
    if e.message =~ /wrong number of arguments/
      original_process(s,f)
    else
      raise
    end
  end
end
# until https://github.com/flyerhzm/code_analyzer/pull/4 is merged and released
# see https://github.com/metricfu/metric_fu/issues/123
require 'code_analyzer'
class Sexp
  begin
    alias_method :block_type, :block
    undef :block
  rescue NameError
    # we're a-okay
  end
end
