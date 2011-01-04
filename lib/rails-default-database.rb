Rails::Application::Configuration.class_eval do

  def database_configuration_with_default
    database_configuration_without_default
  rescue Errno::ENOENT
    name = File.basename(root)
    begin
      require 'pg'
      Hash.new do |h,env|
        h[env] = {
          'adapter' => 'postgresql',
          'database' => "#{name}_#{env}"
        }
      end
    rescue LoadError
      begin
        require 'mysql'
        Hash.new do |h,env|
          h[env] = {
            'adapter' => 'mysql',
            'username' => 'root',
            'database' => "#{name}_#{env}"
          }
        end
      rescue LoadError
        require 'sqlite3'
        Hash.new do |h,env|
          h[env] = {
            'adapter' => 'sqlite3',
            'database' => "db/#{env}.sqlite3"
          }
        end
      end
    end
  end

  alias_method_chain :database_configuration, :default
end
