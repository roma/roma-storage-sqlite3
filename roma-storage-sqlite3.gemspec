lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roma/storage/sqlite3/version"

Gem::Specification.new do |spec|
  spec.name          = "roma-storage-sqlite3"
  spec.version       = Roma::Storage::Sqlite3::VERSION
  spec.authors       = ["Tatsuya Sato"]
  spec.email         = ["satoryu.1981@gmail.com"]

  spec.summary       = %q{SQLite3 storage for ROMA.}
  spec.description   = %q{SQLite3 storage for ROMA. Set Roma::Storage::SQLite3Storage to STORAGE_CLASS in config.rb of ROMA.}
  spec.homepage      = "https://github.com/roma/roma-storage-sqlite3"
  spec.license       = "GPL-3.0-only"
  spec.required_ruby_version = ">= 3.4"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|bin)/|^\.})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'sqlite3'
  spec.add_dependency 'roma-storage', '~> 0.1.0'

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
