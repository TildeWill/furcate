# frozen_string_literal: true

require "bundler/setup"
require "active_record"
require "require_all"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
# ActiveRecord::Base.logger = Logger.new STDOUT

load "#{File.dirname(__FILE__)}/dummy/db/schema.rb"
load "#{File.dirname(__FILE__)}/dummy/app/models/team.rb"
load "#{File.dirname(__FILE__)}/dummy/app/models/person.rb"

require "furcate"

Bundler.setup(:default, :development)
require_all "spec/support"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include TreeHelpers
end
