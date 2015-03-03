RSpec::Matchers.define :create_file do |expected|
  match do |block|
    @before = exists?(expected)
    block.call
    @after = exists?(expected)
    !@before && @after
  end

  failure_message do |_block|
    existed_before_message expected do
      "The file #{expected.inspect} was not created"
    end
  end

  failure_message_when_negated do |_block|
    existed_before_message expected do
      "The file #{expected.inspect} was created"
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
      "The file #{expected.inspect} existed before, so this test doesn't work"
    else
      yield
    end
  end
end
