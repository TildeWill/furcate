# frozen_string_literal: true

module Furcate
  class CommitConflicts
    def self.calculate_conflicts(diff, other_diff)
      conflicts = deleted_in_diff_and_modified_in_other_diff(diff, other_diff)
      conflicts += modified_in_diff_and_deleted_in_other_diff(diff, other_diff)
      conflicts += modified_in_both(diff, other_diff)
      conflicts.compact
    end

    def self.modified_in_both(diff, other_diff)
      diff.modifications.collect do |modification|
        modified_modification = other_diff.modifications.find do |other_modification|
          keys_match?(modification, other_modification) && !attributes_match?(modification, other_modification)
        end
        Conflict.new(:modification, modification, :modification, modified_modification) if modified_modification
      end
    end

    def self.modified_in_diff_and_deleted_in_other_diff(diff, other_diff)
      diff.modifications.collect do |modification|
        modified_deletion = other_diff.deletions.find do |other_deletion|
          keys_match?(modification, other_deletion)
        end
        if modified_deletion
          Conflict.new(:modification, modification, :deletion,
                       modified_deletion)
        end
      end
    end

    def self.deleted_in_diff_and_modified_in_other_diff(diff, other_diff)
      diff.deletions.collect do |deletion|
        deleted_modification = other_diff.modifications.find do |other_modification|
          keys_match?(deletion, other_modification)
        end
        if deleted_modification
          Conflict.new(:deletion, deletion, :modification,
                       deleted_modification)
        end
      end
    end

    def self.keys_match?(leaf, other_leaf)
      leaf.id == other_leaf.id && leaf.type == other_leaf.type
    end

    def self.attributes_match?(leaf, other_leaf)
      leaf.attributes == other_leaf.attributes
    end
  end
end
