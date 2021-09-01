# frozen_string_literal: true

module Furcate
  class Commit < ActiveRecord::Base
    extend Forwardable
    has_many :trees
    has_many :teams, through: :trees

    belongs_to :parent_commit, class_name: "Furcate::Commit"

    def initialize(attributes)
      attributes[:teams] = attributes.delete(:leaves)
      super
    end

    def leaves
      teams
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
  end
end
