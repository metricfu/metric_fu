# https://github.com/rails/rails/blob/e8727d37fc49d5bf9976c3cb5c46badb92cf4ced/activesupport/lib/active_support/core_ext/object/to_json.rb
# Hack to load json gem first so we can overwrite its to_json.
begin
  require 'json'
rescue LoadError
end

# The JSON gem adds a few modules to Ruby core classes containing :to_json definition, overwriting
# their default behavior. That said, we need to define the basic to_json method in all of them,
# otherwise they will always use to_json gem implementation, which is backwards incompatible in
# several cases (for instance, the JSON implementation for Hash does not work) with inheritance
# and consequently classes as ActiveSupport::OrderedHash cannot be serialized to json.
