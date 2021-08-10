# frozen_string_literal: true

module Furcate
  class CommitConflicts
    def self.calculate_conflicts(diff, other_diff)
      conflicts = deleted_in_diff_and_modified_in_other_diff(diff, other_diff)
      conflicts += modified_in_diff_and_deleted_in_other_diff(diff, other_diff)
      conflicts += modified_in_both(diff, other_diff)
      conflicts
    end

    class UnresolvedCommitConflict
      attr_reader :conflict_type, :object, :other_conflict_type, :other_object

      def initialize(conflict_type, object, other_conflict_type, other_object)
        @conflict_type = conflict_type
        @object = object
        @other_conflict_type = other_conflict_type
        @other_object = other_object
      end
    end

    def self.modified_in_both(diff, other_diff)
      diff.modifications.collect do |modification|
        modified_modification = other_diff.modifications.first do |other_modification|
          keys_match?(modification, other_modification) && !attributes_match?(modification, other_modification)
        end
        if modified_modification
          return UnresolvedCommitConflict.new(:modification, modification, :modification, modified_modification)
        end
      end
    end

    def self.modified_in_diff_and_deleted_in_other_diff(diff, other_diff)
      diff.modifications.collect do |modification|
        modified_deletion = other_diff.deletions.first do |other_deletion|
          keys_match?(modification, other_deletion)
        end
        if modified_deletion
          return UnresolvedCommitConflict.new(:modification, modification, :deletion,
                                              modified_deletion)
        end
      end
    end

    def self.deleted_in_diff_and_modified_in_other_diff(diff, other_diff)
      diff.deletions.collect do |deletion|
        deleted_modification = other_diff.modifications.first do |other_modification|
          keys_match?(deletion, other_modification)
        end
        if deleted_modification
          return UnresolvedCommitConflict.new(:deletion, deletion, :modification,
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
