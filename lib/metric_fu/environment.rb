require 'redcard'
MetricFu.logging_require { 'mf_debugger' }
module MetricFu
  module Environment

    def verbose
      MfDebugger::Logger.debug_on
    end

    def verbose=(toggle)
      MfDebugger::Logger.debug_on = toggle
    end

    # Perform a simple check to try and guess if we're running
    # against a rails app.
    #
    # TODO This should probably be made a bit more robust.
    def rails?
      @rails ||= begin
                   exists = File.exist?("config/environment.rb")
                   def MetricFu.rails?
                     exists
                   end
                   exists
                 end
    end

    def is_cruise_control_rb?
      !!ENV['CC_BUILD_ARTIFACTS']
    end

    def jruby?
      @jruby ||= !!RedCard.check(:jruby)
    end

    def mri?
      @mri ||= !!RedCard.check(:ruby)
    end

    def ruby_flavor
      @ruby_flavor ||= RedCard.engine
    end

    def ruby_version
      @ruby_version ||= RedCard.engine_version
    end

    def ruby18?
      @ruby18 ||= mri? && !!RedCard.check('1.8'...'1.9')
    end

    def ruby192?
      @ruby192 ||= mri? && ruby_version == '1.9.2'
    end

    def rubinius?
      @rubinius ||= !!RedCard.check(:rubinius)
    end

    def supports_ripper?
      @supports_ripper ||= begin
                             begin
                               require 'ripper'
                               true
                             rescue LoadError
                               false
                             end
                           end
    end
    def platform #:nodoc:
      return RUBY_PLATFORM
    end

    def osx?
      @osx ||= platform.include?('darwin')
    end

    def ruby_strangely_makes_accessors_private?
       ruby192? || jruby?
    end

    def self.included(host_class)
      def host_class.ruby_strangely_makes_accessors_private?
        @private_accessors ||= allocate.ruby_strangely_makes_accessors_private?
      end
    end
  end
end
