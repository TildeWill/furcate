# frozen_string_literal: true

require "forwardable"
require "active_record"

require "furcate/version"
require "furcate/ancestor"
require "furcate/leaf"
require "furcate/change"
require "furcate/commit"
require "furcate/commit_conflicts"
require "furcate/commit_diff"
require "furcate/deep_clone"
require "furcate/leaf_builder"
require "furcate/merger"
require "furcate/null_commit"
require "furcate/conflict"
require "furcate/furcator"

module Furcate
  def self.current_furcator=(furcator)
    @current_furcator = furcator
  end

  def self.current_furcator
    @current_furcator
  end

  class AnonymousClassNotSupported < StandardError; end
  private_constant :Commit
  private_constant :DeepClone
  private_constant :NullCommit
end
