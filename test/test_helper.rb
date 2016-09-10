ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "mocha/mini_test"

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

# Minitest-reporters is a progress-bar-style reporter by default
# but we can alternatively use a document-style reporter.
# https://github.com/kern/minitest-reporters#caveats
require "minitest/reporters"
Minitest::Reporters.use!(
  # (Minitest::Reporters::SpecReporter.new) # Enable document-style reporter.
)

# Coverage
require 'simplecov'
SimpleCov.start
SimpleCov.add_filter do |src_file|
  /test/ =~ src_file.filename
end

# Shoulda-matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Make FactoryGirl code concise.
  include FactoryGirl::Syntax::Methods
end
