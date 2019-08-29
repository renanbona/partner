# This file is copied to spec/ when you run 'rails generate rspec:install'
require "simplecov"
SimpleCov.start "rails"

require "spec_helper"
require "shoulda/matchers"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "factory_bot"
require "devise"
require "capybara/rails"
require "capybara/rspec"
require "capybara-screenshot/rspec"

# Add additional requires below this line. Rails is not loaded until this point!
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# If an element is hidden, Capybara should ignore it
Capybara.ignore_hidden_elements = true

# https://docs.travis-ci.com/user/chrome
Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu window-size=1680,1050])

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Enable JS for Capybara tests
Capybara.javascript_driver = :chrome

Capybara::Screenshot.autosave_on_failure = true
# The driver name should match the Capybara driver config name.
Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

# Set the asset host so that the screenshots look nice
Capybara.asset_host = "http://localhost:3000"

# Only keep the most recent run
Capybara::Screenshot.prune_strategy = :keep_last_run

# NOTE(chaserx): this is required to include fixture_file_upload in factories
# see also: https://blog.eq8.eu/til/factory-bot-trait-for-active-storange-has_attached.html
#
FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end

# If an element is hidden, Capybara should ignore it
Capybara.ignore_hidden_elements = true

# https://docs.travis-ci.com/user/chrome
Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu window-size=1680,1050])

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Enable JS for Capybara tests
Capybara.javascript_driver = :chrome

Capybara::Screenshot.autosave_on_failure = true
# The driver name should match the Capybara driver config name.
Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

# Set the asset host so that the screenshots look nice
Capybara.asset_host = "http://localhost:3456"

# Only keep the most recent run
Capybara::Screenshot.prune_strategy = :keep_last_run

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # set driver for system tests
  config.before(:each, type: :system) do
    driven_by :chrome
    Capybara.server = :puma, { Silent: true }
  end

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # sign_in helpers for feature specs
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers,  type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.extend ControllerMacros, type: :controller
  config.include RequestSpecHelper, type: :request
  config.include FactoryBot::Syntax::Methods
end
