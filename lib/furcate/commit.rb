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

    def first_common_ancestor(scion_head, scion_commit = scion_head, rootstock_head = self)
      return rootstock_head if rootstock_head == scion_commit
      return scion_commit if rootstock_head.parent_commit == scion_commit

      if scion_commit.parent_commit.nil?
        first_common_ancestor(scion_head.parent_commit || scion_head, scion_head.parent_commit || scion_head,
                              rootstock_head.parent_commit)
      else
        first_common_ancestor(scion_head, scion_commit.parent_commit, rootstock_head)
      end
    end

    def any_matching_keys?(other_leaf)
      leaves.any?{ |leaf| leaf.id == other_leaf.id && leaf.type == other_leaf.type }
    end

    def no_matching_keys?(other_leaf)
      !any_matching_keys?(other_leaf)
    end

    def any_changed_attributes?(other_leaf)
      matching_leaf = leaves.first{ |leaf| leaf.id == other_leaf.id && leaf.type == other_leaf.type }
      matching_leaf.attributes != other_leaf.attributes
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
