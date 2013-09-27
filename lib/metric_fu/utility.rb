module MetricFu
  module Utility
    module_function

    # Removes non-ASCII characters
    def clean_ascii_text(text)
      if text.respond_to?(:encode)
        # avoids invalid multi-byte escape error
        ascii_text = text.encode( 'ASCII', invalid: :replace, undef: :replace, replace: '' )
        # see http://www.ruby-forum.com/topic/183413
        pattern = Regexp.new('[\x80-\xff]', nil, 'n')
        ascii_text.gsub(pattern, '')
      else
        text
      end
    end

    def rm_rf(*args)
      FileUtils.rm_rf(*args)
    end

    def mkdir_p(*args)
      FileUtils.mkdir_p(*args)
    end

  end
end
