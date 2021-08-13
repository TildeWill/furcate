# frozen_string_literal: true

module Furcate
  class CommitDiff
    attr_reader :additions, :deletions, :modifications

    def initialize(additions, deletions, modifications)
      @additions = additions.freeze
      @deletions = deletions.freeze
      @modifications = modifications.freeze
    end

    def self.diff(commit, other_commit)
      additions = commit.leaves.select do |leaf|
        other_commit.no_matching_keys?(leaf)
      end
      deletions = other_commit.leaves.select do |leaf|
        commit.no_matching_keys?(leaf)
      end
      modifications = commit.leaves.select do |leaf|
        other_commit.any_changed_attributes?(leaf)
      end

      CommitDiff.new(additions, deletions, modifications)
    end

    def same?
      additions.empty? && deletions.empty? && modifications.empty?
    end
  end
end
