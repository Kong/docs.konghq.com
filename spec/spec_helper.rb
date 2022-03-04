# Require all of the necessary gems
require "rspec"
require "capybara/rspec"
require "rack/jekyll"
require "rack/test"
require "pry"
require "capybara/apparition"
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Configure Capybara to load the website through rack-jekyll.
  # (force_build: true) builds the site before the tests are run,
  # so our tests are always running against the latest version
  # of our jekyll site.

  Capybara.server = :puma, { Silent: true }

  Capybara.register_driver :apparition do |app|
    Capybara::Apparition::Driver.new(app, { :headless => true, :window_size => [1366, 768] })
  end
  Capybara.javascript_driver = :apparition
  Capybara.app = Rack::Jekyll.new(force_build: false, config: "jekyll.yml")
end
