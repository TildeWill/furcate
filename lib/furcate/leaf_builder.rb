# frozen_string_literal: true

module Furcate
  class LeafBuilder
    def self.graft(parent_commit, change)
      previous_leaves = parent_commit ? parent_commit.leaves : []
      leaves = build_new_leaves(Array.new(previous_leaves), change)
      leaves.freeze
    end

    def self.build_new_leaves(leaves, change)
      case change.change_type
      when :deletion
        delete(leaves, change.leaf)
      when :addition
        add(leaves, change.leaf)
      when :modification
        modify(leaves, change.leaf)
      end
      leaves
    end

    def self.delete(leaves, change_leaf)
      leaves.delete_if { |leaf| leaf.id == change_leaf.id && leaf.type == change_leaf.type }
    end

    def self.add(leaves, change_leaf)
      leaves << DeepClone.clone(change_leaf)
    end

    def self.modify(leaves, change_leaf)
      delete(leaves, change_leaf)
      add(leaves, change_leaf)
    end
  end
end
