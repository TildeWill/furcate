# frozen_string_literal: true

module Furcate
  class Commit
    attr_reader :message, :parent_commit, :leaves

    def initialize(message, parent_commit, stage)
      @message = message
      @parent_commit = parent_commit
      previous_leaves = parent_commit ? parent_commit.leaves : []
      @leaves = build_new_leaves(Array.new(previous_leaves), stage)
      @leaves.freeze
    end

    def find(&block)
      @leaves.find(&block)
    end

    private

    def build_new_leaves(leaves, stage)
      # add the additions from the staged tree
      stage.additions.each do |change|
        leaves << change
      end

      stage.deletions.each do |change|
        leaves.delete(change)
      end

      leaves
    end
  end
end
