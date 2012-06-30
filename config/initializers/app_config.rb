# Loading config file
config = YAML.load_file( "#{Rails.root}/config/config.yml" ) || {}
AppConfig = config[ Rails.env ] || {}