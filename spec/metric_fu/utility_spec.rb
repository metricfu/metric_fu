require "spec_helper"
require "metric_fu/utility"

describe MetricFu::Utility do
  it "strips ANSI escape codes from text" do
    text = "\e[31m./app/models/account.rb:64 - Found = in conditional.  It should probably be an ==\e[0m"
    output = "./app/models/account.rb:64 - Found = in conditional.  It should probably be an =="

    result = MetricFu::Utility.strip_escape_codes(text)
    expect(result).to eq(output)
  end
end
