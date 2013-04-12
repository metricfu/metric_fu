source 'https://rubygems.org'

gem 'rake'
group :development, :test do
  gem "rspec", '>2'
  gem "test-construct", ">= 1.2.0"
  gem "googlecharts"
  if ENV['COVERAGE']
    gem 'simplecov'
    # https://github.com/kina/simplecov-rcov-text
    gem 'simplecov-rcov-text'
  end
end
gemspec
