Rails::Application::Configuration.class_eval do

  def database_configuration_with_default
    config_file =
      begin
        database_configuration_without_default
      rescue Errno::ENOENT, RuntimeError
      end || {}

    default_database_configuration.merge(config_file)
  end

  def default_database_configuration
    name = File.basename(root)
    driver = %w(pg mysql mysql2 sqlite3).detect do |a|
      begin
        require a
        true
      rescue LoadError
      end
    end
    defaults =
      case driver
      when 'pg'
        {
          'adapter' => 'postgresql',
          'min_messages' => 'warning'
        }
      when 'mysql'
        {
          'adapter' => 'mysql',
          'username' => 'root'
        }
      when 'mysql2'
        {
          'adapter' => 'mysql2',
          'username' => 'root'
        }
      when 'sqlite3'
        {
          'adapter' => 'sqlite3',
          'database' => 'db/%s.sqlite3'
        }
      else
        {}
      end
    defaults['database'] ||= "#{name}_%s"

    %w(development test production).inject({}) do |h, env|
      h[env] = defaults.merge(
        'database' => defaults['database'].gsub('%s', env)
      )
      h
    end
  end

  alias_method_chain :database_configuration, :default
end

class RailsDefaultDatabaseRailtie < Rails::Railtie
  rake_tasks do
    load 'rails-default-database.rake'
  end
end
