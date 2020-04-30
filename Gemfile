# encoding: utf-8
source "https://rubygems.org"

gemspec path: File.expand_path("..", __FILE__)

platform :jruby do
  group :jruby do
    gem "jruby-openssl", "~> 0.9.17"
  end
end

group :test, :local_development  do
  gem "pry"
  gem "pry-nav"
end

# Added by devtools
group :development do
  gem "rake",  "~> 10.1.0"
  gem "yard",  "~> 0.8.7", group: :yard
end
