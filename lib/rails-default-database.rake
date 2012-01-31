desc 'Write out config/database.yml from rails-default-database'
task 'db:config' do
  contents = Rails.configuration.database_configuration.to_yaml
  File.open(Rails.root.join('config/database.yml'), 'w') do |f|
    f.puts contents.sub(/^---\n/, '')
  end
end
