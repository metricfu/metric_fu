module MetricFu
  class Location
    include Comparable

    attr_accessor :file_path, :file_name, :line_number,
                  :class_name, :method_name, :simple_method_name, :hash, :hash_key

    def self.get(file_path, class_name, method_name)
      location = new(file_path, class_name, method_name)
      @@locations ||= {}
      @@locations.fetch(location.hash_key) do
        @@locations[location.hash_key] = location
        location.finalize
        location
      end
    end

    def initialize(file_path, class_name, method_name)
      @file_path               = file_path
      @file_name, @line_number = file_path.to_s.split(/:/)
      @class_name              = class_name
      @method_name             = method_name
      @simple_method_name      = @method_name.to_s.sub(@class_name.to_s, "")
      @hash_key                = to_key
      @hash                    = @hash_key.hash
    end

    def to_hash
      hash = {
        "class_name"  => class_name,
        "method_name" => method_name,
        "file_path"   => file_path,
        "file_name"   => file_name,
        "line_number" => line_number,
        "hash_key"    => hash_key,
      }

      if method_name.to_s.size > 0
        hash = hash.merge("simple_method_name" => simple_method_name)
      else
        hash
      end
    end

    # defining :eql? and :hash to use Location as a hash key
    def eql?(other)
      @hash == other.hash
    end

    def <=>(other)
      hash <=> other.hash
    end

    # Generates the @hash key
    def to_key
      [@file_path, @class_name, @method_name].inspect
    end

    def self.for(class_or_method_name)
      class_or_method_name = strip_modules(class_or_method_name)
      if class_or_method_name
        begin
          match = class_or_method_name.match(/(.*)((\.|\#|\:\:[a-z])(.+))/)
        rescue => error
          # new error during port to metric_fu occasionally a unintialized
          # MatchData object shows up here. Not expected.
          mf_debug "ERROR on getting location for #{class_or_method_name} #{error.inspect}"
          match = nil
        end

        # reek reports the method with :: not # on modules like
        # module ApplicationHelper \n def signed_in?, convert it so it records correctly
        # but classes have to start with a capital letter... HACK for REEK bug, reported underlying issue to REEK
        if match
          class_name = strip_modules(match[1])
          method_name = class_or_method_name.gsub(/\:\:/, "#")
        else
          class_name = strip_modules(class_or_method_name)
          method_name = nil
        end
      else
        class_name = nil
        method_name = nil
      end
      get(nil, class_name, method_name)
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
      if class_or_method_name =~ /\:\:[A-Z]/
        class_or_method_name.split("::").last
      else
        class_or_method_name
      end
    end
  end
end
