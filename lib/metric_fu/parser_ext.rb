# For Flog
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
