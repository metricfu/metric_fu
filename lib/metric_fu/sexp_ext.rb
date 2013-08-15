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
