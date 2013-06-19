module MetricFu
  class Location
    include Comparable

    attr_accessor :file_path, :file_name, :line_number,
                  :class_name, :method_name, :simple_method_name, :hash

    def self.get(file_path, class_name, method_name)
      location = new(file_path, class_name, method_name)
      @@locations ||= {}
      @@locations.fetch(location.to_key) do
        @@locations[location.to_key] = location
        location.finalize
        location
      end
    end

    def initialize(file_path, class_name, method_name)
      @file_path          = file_path
      @file_name, @line_number = file_path.to_s.split(/:/)
      @class_name         = class_name
      @method_name        = method_name
      @simple_method_name = @method_name.to_s.sub(@class_name.to_s,'')
      @hash               = to_key.hash
    end

    # TODO - we need this method (and hash accessor above) as a temporary hack where we're using Location as a hash key
    def eql?(other)
      # REMOVED per https://github.com/jscruggs/metric_fu/pull/67/files
      # [self.file_path.to_s, self.class_name.to_s, self.method_name.to_s] == [other.file_path.to_s, other.class_name.to_s, other.method_name.to_s]
      @hash == other.hash
    end
    # END we need these methods as a temporary hack where we're using Location as a hash key

    def self.for(class_or_method_name)
      class_or_method_name = strip_modules(class_or_method_name)
      if(class_or_method_name)
        begin
          match = class_or_method_name.match(/(.*)((\.|\#|\:\:[a-z])(.+))/)
        rescue => error
          #new error during port to metric_fu occasionally a unintialized
          #MatchData object shows up here. Not expected.
          match = nil
        end

        # reek reports the method with :: not # on modules like
        # module ApplicationHelper \n def signed_in?, convert it so it records correctly
        # but classes have to start with a capital letter... HACK for REEK bug, reported underlying issue to REEK
        if(match)
          class_name = strip_modules(match[1])
          method_name = class_or_method_name.gsub(/\:\:/,"#")
        else
          class_name = strip_modules(class_or_method_name)
          method_name = nil
        end
      else
        class_name = nil
        method_name = nil
      end
      self.get(nil, class_name, method_name)
    end

    def <=>(other)
      [self.file_path.to_s, self.class_name.to_s, self.method_name.to_s] <=> [other.file_path.to_s, other.class_name.to_s, other.method_name.to_s]
    end

    def to_key
      [@file_path, @class_name, @method_name]
    end

    def finalize
      @file_path   &&= @file_path.clone
      @file_name   &&= @file_name.clone
      @line_number &&= @line_number.clone
      @class_name  &&= @class_name.clone
      @method_name &&= @method_name.clone
      freeze  # we cache a lot of method call results, so we want location to be immutable
    end

    private

    def self.strip_modules(class_or_method_name)
      # reek reports the method with :: not # on modules like
      # module ApplicationHelper \n def signed_in?, convert it so it records correctly
      # but classes have to start with a capital letter... HACK for REEK bug, reported underlying issue to REEK
      if(class_or_method_name=~/\:\:[A-Z]/)
        class_or_method_name.split("::").last
      else
        class_or_method_name
      end

    end

  end
end
