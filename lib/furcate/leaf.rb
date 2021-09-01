# frozen_string_literal: true

require "active_record"

module Furcate
  class Leaf < ActiveRecord::Base
    def type
      self.class.name || ""
    end

    def id
      furcate_id
    end

    def self.create(attributes = {})
      leaf = super
      change = Change.new(leaf, :addition)
      Furcate.current_furcator.make_commit(change)
      leaf
    end

    def delete
      change = Change.new(self, :deletion)
      Furcate.current_furcator.make_commit(change)
    end

    def update(attributes = {})
      record = self.class.new(self.attributes.except("id").merge(attributes))
      record.save
      change = Change.new(record, :modification)
      Furcate.current_furcator.make_commit(change)
    end

    def self.find(furcate_id)
      Furcate.current_furcator.find(furcate_id)
    end

    def diff(other_leaf)
      return :no_match unless id == other_leaf.id && type == other_leaf.type
      return :changed unless Marshal.dump(self) == Marshal.dump(other_leaf)

      :no_change
    end
  end
end
