# frozen_string_literal: true

module Furcate
  class Stage
    attr_reader :staged_changes

    def initialize
      @staged_changes = []
    end

    def add(leaf)
      @staged_changes << Change.new(leaf, :addition)
    end

    def delete(leaf)
      @staged_changes << Change.new(leaf, :deletion)
    end

    def modify(leaf)
      @staged_changes << Change.new(leaf, :modification)
    end
  end
end
