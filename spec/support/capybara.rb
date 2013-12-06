require 'capybara/poltergeist'

Capybara.default_wait_time = 2 # Seconds to wait before timeout error. Default is 2

# Register slightly larger than default window size...
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { debug: false, # change this to true to troubleshoot
                                           window_size: [1300, 1000] # this can affect dynamic layout
  })
end
Capybara.javascript_driver = :poltergeist

# Saves page to place specfied at name inside of
# test.rb definition of:
#   config.integration_test_render_dir = Rails.root.join("spec", "render")
# NOTE: you must pass "js:" for the scenario definition (or else you'll see that render doesn't exist!)
def render_page(name)
  png_name = name.strip.gsub(/\W+/, '-')
  path = File.join(Rails.application.config.integration_test_render_dir, "#{png_name}.png")
  page.driver.render(path)
end

# shortcut for typing save_and_open_page
def page!
  save_and_open_page
end
