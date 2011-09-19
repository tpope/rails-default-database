Rails::Application::Configuration.class_eval do

  def database_configuration_with_default
    config_file =
      begin
        database_configuration_without_default
      rescue Errno::ENOENT
      end || {}

    default_config.merge(config_file)
  end

  private

  def default_config
    name = File.basename(root)
    generator = begin
      require 'pg'
      lambda do |env|
        {
          'adapter' => 'postgresql',
          'min_messages' => 'warning',
          'database' => "#{name}_#{env}"
        }
      end
    rescue LoadError
      begin
        require 'mysql'
        lambda do |env|
          {
            'adapter' => 'mysql',
            'username' => 'root',
            'database' => "#{name}_#{env}"
          }
        end
      rescue LoadError
        begin
          require 'mysql2'
          lambda do |env|
            {
              'adapter' => 'mysql2',
              'username' => 'root',
              'database' => "#{name}_#{env}"
            }
          end
        rescue LoadError
          require 'sqlite3'
          lambda do |env|
            {
              'adapter' => 'sqlite3',
              'database' => "db/#{env}.sqlite3"
            }
          end
        end
      end
    end

    %w(development test production).inject({}) do |h, env|
      h.update(env => generator.call(env))
    end
  end

  alias_method_chain :database_configuration, :default
end
