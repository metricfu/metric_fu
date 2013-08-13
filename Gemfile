source 'https://rubygems.org'

gem 'rake'
# alternative graphing gem
gem "googlecharts"
group :development do
  gem 'debugger'
end
group :test do
  gem "rspec", '>2'
  gem 'test-construct'
  if ENV['COVERAGE']
    gem 'simplecov'
    # https://github.com/kina/simplecov-rcov-text
    gem 'simplecov-rcov-text'
  end
  gem "fakefs", :require => "fakefs/safe"
  gem 'json'
end
gemspec :path => File.expand_path('..', __FILE__)
