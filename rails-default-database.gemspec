Gem::Specification.new do |s|
  s.name                = "rails-default-database"
  s.version             = "1.1.2"

  s.summary             = "Make database.yml optional in Rails"
  s.description         = "Provides a default database configuration for Rails applications that lack one"
  s.authors             = ["Tim Pope"]
  s.email               = "ruby@tpope.o"+'rg'
  s.homepage            = "http://github.com/tpope/rails-default-database"
  s.files               = [
    "README.markdown",
    "MIT-LICENSE",
    "lib/rails-default-database.rb",
    "lib/rails-default-database.rake",
  ]
  s.add_runtime_dependency("railties")
end
