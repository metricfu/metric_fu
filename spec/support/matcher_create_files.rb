RSpec::Matchers.define :create_files do |expected|
  match do |block|
    @before = false
    @after = true
    expected.each do |file|
      @before |= exists?(file)
    end
    block.call
    expected.each do |file|
      @after &= exists?(file)
    end
    !@before && @after
  end

  failure_message do |_block|
    existed_before_message expected do
      "One or more files in [#{expected.inspect}] was not created."
    end
  end

  failure_message_when_negated do |_block|
    existed_before_message expected do
      "The files in [#{expected.inspect}] were created."
    end
  end

  def supports_block_expectations?
    true
  end

  def exists?(expected)
    # Allows us to use wildcard checks for existence.
    !Dir.glob(expected).empty?
  end

  def existed_before_message(expected)
    if @before
      "One or more files in  [#{expected.inspect}] existed before, so this test doesn't work"
    else
      yield
    end
  end
end
