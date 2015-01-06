Airbrake.configure do |config|
  config.api_key = '6289bd1e1391f09316c43d3e870a858f'
  config.host    = 'errbit.mpugach.net'
  config.port    = 80
  config.secure  = config.port == 443
end
