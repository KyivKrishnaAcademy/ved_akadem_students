if Rails.env.production?
  Airbrake.configure do |config|
    config.host         = 'errbit.mpugach.net'
    config.project_id   = '6289bd1e1391f09316c43d3e870a858f'
    config.project_key  = '6289bd1e1391f09316c43d3e870a858f'
  end
end
