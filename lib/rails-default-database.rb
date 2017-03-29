Rails::Application::Configuration.class_eval do

  def environments_for_database_configuration
    ['development', 'test', 'production'] |
      root.join('config', 'environments').children.map do |e|
        e.basename('.rb').to_s if e.extname == '.rb'
      end.compact.sort
  end

  def database_configuration_with_default
    config =
      begin
        database_configuration_without_default
      rescue Errno::ENOENT, RuntimeError
      end || {}

    if url = ENV['DATABASE_URL'].presence
      (environments_for_database_configuration | config.keys).each do |k|
        config[k] = {'url' => url.gsub('%s', k)}
        if k == 'test'
          config[k]['url'] =
            config[k]['url'].sub(/(?:_(?:#{environments_for_database_configuration.join('|')})(?:\d*|%i))?(?=\?|$)/, "_test")
        end
      end
      config
    else
      default_database_configuration.merge(config)
    end.tap do |c|
      if ENV['TEST_DATABASE_URL'].present?
        c['test'] = {'url' => ENV['TEST_DATABASE_URL']}
      end
      %w(url database).each do |key|
        if value = c['test'] && c['test'][key]
          c['test'][key] = value.sub(/%i/, ENV['TEST_ENV_NUMBER'].to_s)
        end
      end
    end
  end

  def default_database_configuration
    name = File.basename(root).gsub(/[^[:alnum:]]+/, '_')
    driver = %w(pg mysql2 mysql sqlite3).detect do |a|
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
      when 'sqlite3'
        {
          'adapter' => 'sqlite3',
          'database' => 'db/%s.sqlite3'
        }
      when nil
        {}
      else
        {'adapter' => driver}
      end
    defaults['database'] ||= "#{name}_%s"

    environments_for_database_configuration.inject({}) do |h, env|
      h[env] = defaults.merge(
        'database' => defaults['database'].gsub('%s', "#{env}#{'%i' if env == 'test'}")
      )
      h
    end
  end

  unless method_defined?(:database_configuration_without_default)
    alias database_configuration_without_default database_configuration
    alias database_configuration database_configuration_with_default
  end
end

class RailsDefaultDatabaseRailtie < Rails::Railtie
  rake_tasks do
    load 'rails-default-database.rake'
  end
end
