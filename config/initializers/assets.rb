# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  crops.js
  Jcrop/css/Jcrop.css
  Jcrop/js/Jcrop.js
  Jcrop/css/Jcrop.gif

  generated/app-bundle.js
  generated/server-bundle.js
  generated/react-bundle.js
  generated/schedule-list-bundle.js
  generated/group-attendance-bundle.js

  cert_template_markup.js

  forgot_email.js

  nested_form_custom_telephones.js

  intl-tel-input/build/img/flags.png
  intl-tel-input/build/css/intlTelInput
  intl-tel-input/build/js/intlTelInput
  intl-tel-input/build/js/utils

  select2.min.js
  select2.min.css

  sentry-raven.js
)

# Add client/assets/ folders to asset pipeline's search path.
# If you do not want to move existing images and fonts from your Rails app
# you could also consider creating symlinks there that point to the original
# rails directories. In that case, you would not add these paths here.
Rails.application.config.assets.paths << Rails.root.join('client/assets/stylesheets')
Rails.application.config.assets.paths << Rails.root.join('client/assets/images')
Rails.application.config.assets.paths << Rails.root.join('client/assets/fonts')

Rails.application.config.assets.paths << Rails.root.join('node_modules')
