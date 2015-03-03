module MetricFu
  module Constantize
    # Copied from ActiveSupport and modified so as not to introduce a dependency.
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflector/methods.rb#L220
    def constantize(camel_cased_word)
      tries ||= 2
      names = camel_cased_word.split("::")
      names.shift if names.empty? || names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check it it's owned
          # directly before we reach Object or the end of ancestors.
          constant = constant.ancestors.inject do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    rescue NameError
      # May need to attempt to require the file and try again.
      begin
        require underscore(camel_cased_word)
      rescue LoadError => e
        mf_log e.message
      end

      if (tries -= 1).zero?
        raise
      else
        retry
      end
    end

    # Copied from active_support
    # https://github.com/rails/rails/blob/51cd6bb829c418c5fbf75de1dfbb177233b1b154/activesupport/lib/active_support/inflector/methods.rb#L88
    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, "/")
      word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
