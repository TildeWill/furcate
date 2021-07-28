# frozen_string_literal: true

module Furcate
  class Stage
    def initialize(additions = [], deletions = [])
      @changes = {}
      additions.each{ |addition| @changes[addition] = :addition }
      deletions.each{ |deletion| @changes[deletion] = :deletion }
    end

    def add(leaf)
      @changes[leaf] = :addition
    end

    def delete(leaf)
      @changes[leaf] = :deletion
    end

    def staged_changes
      @changes
    end

    def additions
      @changes.filter{ |_, change_type| change_type == :addition }.keys
    end

    def deletions
      @changes.filter{ |_, change_type| change_type == :deletion }.keys
    end
  end
end
