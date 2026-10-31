# roma-storage-sqlite3

An SQLite3 storage for [ROMA](https://github.com/roma/roma), a distributed key-value store.

## Installation

Add this line to the Gemfile of your ROMA server:

```ruby
gem 'roma-storage-sqlite3'
```

And then run `bundle install`. Or install it yourself:

    $ gem install roma-storage-sqlite3



## Usage

In the config.rb of ROMA, require the storage and set it to `STORAGE_CLASS`:

```ruby
require 'roma/storage/sqlite3'

module Roma
  module Config
    # ...
    STORAGE_CLASS = Roma::Storage::SQLite3Storage
    # ...
  end
end
```

Each node keeps its data in `STORAGE_PATH/<node-id>/<hash-name>/`, divided into `STORAGE_DIVNUM` files named `0.sql3`, `1.sql3` and so on.

## Development

Run `bundle install`, then `bundle exec rake spec` to run the tests.

## License

GPL-3.0. See LICENSE.txt.
