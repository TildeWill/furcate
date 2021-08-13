# frozen_string_literal: true

require "active_record"

module Furcate
  class Base
    attr_accessor :id, :type, :attributes

    def initialize
      @attributes = {}
    end

    def create
      Furcate.current_furcator.stage_addition(self)
    end

    def delete
      Furcate.current_furcator.stage_deletion(self)
    end

    def update
      Furcate.current_furcator.stage_modification(self)
    end

    def self.find(object_id)
      Furcate.current_furcator.find{ |furcateable| furcateable.object_id == object_id }
    end

    def sha
      p Marshal.dump(self)
    end

    def diff(other_leaf)
      return :no_match unless id == other_leaf.id && type == other_leaf.type
      return :changed unless Marshal.dump(self) == Marshal.dump(other_leaf)

      :no_change
    end
  end
end
