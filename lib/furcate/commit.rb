# frozen_string_literal: true

module Furcate
  class Commit
    extend Forwardable

    attr_reader :parent_commit, :leaves

    def initialize(parent_commit, stage)
      @parent_commit = parent_commit
      previous_leaves = parent_commit ? parent_commit.leaves : []
      @leaves = build_new_leaves(Array.new(previous_leaves), stage)
      @leaves.freeze
    end

    def find(furcate_id)
      leaves.find{ |leaf| leaf.id == furcate_id }
    end

    def any_matching_keys?(other_leaf)
      leaves.any?{ |leaf| leaf.id == other_leaf.id && leaf.type == other_leaf.type }
    end

    def no_matching_keys?(other_leaf)
      !any_matching_keys?(other_leaf)
    end

    def any_changed_attributes?(other_leaf)
      matching_leaf = leaves.find{ |leaf| leaf.id == other_leaf.id && leaf.type == other_leaf.type }
      matching_leaf && matching_leaf.attributes != other_leaf.attributes
    end

    private

    def build_new_leaves(leaves, stage)
      stage.staged_changes.each do |change|
        case change.change_type
        when :deletion
          delete(leaves, change.leaf)
        when :addition
          add(leaves, change.leaf)
        when :modification
          modify(leaves, change.leaf)
        end
      end
      leaves
    end

    def delete(leaves, change_leaf)
      leaves.delete_if { |leaf| leaf.id == change_leaf.id && leaf.type == change_leaf.type }
    end

    def add(leaves, change_leaf)
      leaves << DeepClone.clone(change_leaf)
    end

    def modify(leaves, change_leaf)
      delete(leaves, change_leaf)
      add(leaves, change_leaf)
    end
  end
end
