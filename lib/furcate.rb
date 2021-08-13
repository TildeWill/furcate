# frozen_string_literal: true

require "furcate/version"
require "furcate/base"
require "furcate/change"
require "furcate/commit"
require "furcate/commit_conflicts"
require "furcate/commit_diff"
require "furcate/deep_clone"
require "furcate/stage"
require "furcate/merger"
require "furcate/unresolved_conflict"
require "furcate/furcator"

module Furcate
  def self.current_furcator=(furcator)
    @current_furcator = furcator
  end

  def self.current_furcator
    @current_furcator
  end
end
