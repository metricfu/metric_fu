module MetricFu
  class Record
    attr_reader :data

    def initialize(data, _columns)
      @data = data
    end

    def method_missing(name, *args, &block)
      key = name.to_s
      if key == "fetch"
        @data.send(name, *args, &block)
      elsif @data.has_key?(key)
        @data[key]
      else
        super(name, *args, &block)
      end
    end

    def []=(key, value)
      @data[key] = value
    end

    def [](key)
      @data[key]
    end

    def has_key?(key)
      @data.has_key?(key)
    end
  end
end
