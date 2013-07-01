module MfDebugger
  extend self

  class Logger
    class << self
      attr_accessor :debug_on
      @debug_on = false
    end
    def self.log(msg, &block)
      if block_given?
        block.call
      end
      STDOUT.puts '*'*5 + msg.to_s
    end
    def self.debug(msg, &block)
      if MfDebugger::Logger.debug_on
        if block_given?
          log(msg,&block)
        else
          log(msg)
        end
      end
    end
    # From episode 029 of Ruby Tapas by Avdi
    # https://rubytapas.dpdcart.com/subscriber/post?id=88
    def self.capture_output(&block)
      old_stdout = STDOUT.clone
      pipe_r, pipe_w = IO.pipe
      pipe_r.sync    = true
      output         = ""
      reader = Thread.new do
        begin
          loop do
            output << pipe_r.readpartial(1024)
          end
        rescue EOFError
        end
      end
      STDOUT.reopen(pipe_w)
      yield
    ensure
      STDOUT.reopen(old_stdout)
      pipe_w.close
      reader.join
      return output
    end
  end

  def mf_debug(msg,&block)
    MfDebugger::Logger.debug(msg, &block)
  end

  def mf_log(msg,&block)
    MfDebugger::Logger.log(msg, &block)
  end

end
