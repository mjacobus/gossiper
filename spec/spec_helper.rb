# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'

SimpleCov.start 'rails' do
end

require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'shoulda-matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
if defined?(ActiveRecord::Migration) && ActiveRecord::Migration.respond_to?(:check_pending!)
  ActiveRecord::Migration.check_pending!
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
