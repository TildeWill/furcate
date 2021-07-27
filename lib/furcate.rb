# frozen_string_literal: true

require "furcate/version"
require "furcate/base"
require "furcate/commit"
require "furcate/stage"
require "furcate/furcator"

module Furcate
  def self.current_furcator=(furcate)
    @@current_furcate = furcate
  end

  def self.current_furcator
    @@current_furcate
  end
end
