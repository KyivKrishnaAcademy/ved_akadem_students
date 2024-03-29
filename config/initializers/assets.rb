# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w[
  crops.js
  Jcrop.min.css
  Jcrop.min.js
  Jcrop.gif

  generated/app-bundle.js
  generated/server-bundle.js
  generated/react-bundle.js
  generated/advanced-search-bundle.js
  generated/schedule-list-bundle.js
  generated/group-attendance-bundle.js
  generated/group-performance-bundle.js

  forgot_email.js

  nested_form_custom_telephones.js

  intl-tel-input/build/img/flags.png
  intl-tel-input/build/css/intlTelInput
  intl-tel-input/build/js/intlTelInput
  intl-tel-input/build/js/utils

  select2/dist/js/select2.min.js
  select2/dist/js/i18n/uk.js
  select2/dist/js/i18n/ru.js
  select2/dist/css/select2.min.css
  select2-bootstrap-theme/dist/select2-bootstrap.min.css

  range-slider

  sentry-raven.js
]

# Add client/assets/ folders to asset pipeline's search path.
# If you do not want to move existing images and fonts from your Rails app
# you could also consider creating symlinks there that point to the original
# rails directories. In that case, you would not add these paths here.
Rails.application.config.assets.paths << Rails.root.join('client/assets/stylesheets')
Rails.application.config.assets.paths << Rails.root.join('client/assets/images')
Rails.application.config.assets.paths << Rails.root.join('client/assets/fonts')

Rails.application.config.assets.paths << Rails.root.join('node_modules')
