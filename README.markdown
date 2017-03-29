# Rails Default Database

Tired of `cp config/database.example.yml config/database.yml`? Me too.
That's why I wrote this Gem.  Simply add this line to your Gemfile and
PostgreSQL, MySQL, or SQLite3 (depending on which of the 3 is in your
Gemfile) will be automatically configured with Rails defaults:

    gem 'rails-default-database'

You can still override the defaults by creating `config/database.yml`.
Use `rake db:config` to create `config/database.yml` with the defaults
that would have been assumed.

The default database name is based on the name of the root directory of your
application.  This can be overridden by setting
`config.database_name = 'foo_%s'` in `config/application.rb`, with `%s` being
a placeholder for the current environment name.

As in standard Rails, the `DATABASE_URL` environment variable takes
precedence when defined.  However, in the test environment, Rails Default
Database will append `_test` to the database name (after stripping an optional
existing environment suffix), ensuring the development (or production!)
database is never clobbered.  This enables storing your database configuration
in [`.env`](https://github.com/bkeepers/dotenv), if you so choose.

## License

Copyright (c) Tim Pope.  MIT License.
