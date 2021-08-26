# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Public API vs. private classes and methods" do
  it "does not allow access to the Commit class outside the module" do
    expect(Object.const_defined?("Furcate::Commit")).to be_truthy
    expect(defined?(Furcate::Commit)).to be_falsey
  end
end
