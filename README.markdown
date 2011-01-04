# Rails Default Database

Tired of `cp config/database.example.yml config/database.yml`? Me too.
That's why I wrote this Gem.  Simply add this line to your Gemfile and
PostgreSQL, MySQL, or SQLite3 (depending on which of the 3 is in your
Gemfile) will be automatically configured with Rails defaults:

    gem 'rails-default-database'

You can still override the defaults by creating `config/database.yml`.
