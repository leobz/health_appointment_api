require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HealthAppointmentApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end

# ************************************   OpenApi Doc Config  ***********************************
require 'rspec/openapi'

RSpec::OpenAPI.title = 'Health Appointment API'

# Change `info.version`
RSpec::OpenAPI.application_version = '1.0.0'

# Set `servers` - generate servers of a schema file
RSpec::OpenAPI.servers = [{ url: 'http://localhost:3000' }]

# Generate a custom tags, given an RSpec example
# This example uses the tags from the parent_example_group
RSpec::OpenAPI.tags_builder = -> (example) { [example.metadata.dig(:example_group, :parent_example_group, :description)] }