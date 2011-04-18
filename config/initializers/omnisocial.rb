Omnisocial.setup do |config|
  
  yaml = YAML.load_file("#{RAILS_ROOT}/config/webapi.yml")[RAILS_ENV]
  # ==> Twitter
  config.twitter yaml["twitter"]["api_key"], yaml["twitter"]["secret_key"]
  
  # ==> Facebook
  config.facebook yaml["facebook"]["api_key"], yaml["facebook"]["secret_key"], :scope => 'publish_stream'
  
  if Rails.env.production?
    
    # Configs for production mode go here
    
  elsif Rails.env.development?
    
    # Configs for development mode go here
    
  end
  
end
