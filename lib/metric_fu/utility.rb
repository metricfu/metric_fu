require "yaml"
require "fileutils"
module MetricFu
  module Utility
    module_function

    ESCAPE_CODES_PATTERN = Regexp.new('\e\[(?:\d;)?\d{1,2}m')

    # Removes non-ASCII characters
    def clean_ascii_text(text)
      if text.respond_to?(:encode)
        # avoids invalid multi-byte escape error
        ascii_text = text.encode("ASCII", invalid: :replace, undef: :replace, replace: "")
        # see http://www.ruby-forum.com/topic/183413
        pattern = Regexp.new('[\x80-\xff]', nil, "n")
        ascii_text.gsub(pattern, "")
      else
        text
      end
    end

    def strip_escape_codes(text)
      text.gsub(ESCAPE_CODES_PATTERN, "")
    end

    def rm_rf(*args)
      FileUtils.rm_rf(*args)
    end

    def mkdir_p(*args)
      FileUtils.mkdir_p(*args)
    end

    def glob(*args)
      Dir.glob(*args)
    end

    def load_yaml(file)
      YAML.load_file(file)
    end

    def binread(file)
      File.binread(file)
    end

    # From episode 029 of Ruby Tapas by Avdi
    # https://rubytapas.dpdcart.com/subscriber/post?id=88
    def capture_output(stream = STDOUT, &_block)
      old_stdout = stream.clone
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
      stream.reopen(pipe_w)
      yield
    ensure
      stream.reopen(old_stdout)
      pipe_w.close
      reader.join
      pipe_r.close
      return output
    end
  end
end
