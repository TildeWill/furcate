# frozen_string_literal: true

module Furcate
  class Change
    attr_accessor :change_type, :leaf

    def initialize(leaf, change_type)
      @leaf = leaf
      @change_type = change_type
    end
  end
end
