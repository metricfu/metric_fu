class BadCode
  def nonsense(some_input, options)
    x = Array(some_input).map(&:to_s)
    BadCode.configure do |config|
      config.something.each do |y|
        name = y.name.to_s
        if x.include?(name)
          feature.enabled = true
        else
          feature.enabled = false
        end
      end
    end
    do_it(options)
  end
end
