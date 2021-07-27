# frozen_string_literal: true

module Furcate
  class Base
    def create
      Furcate.current_furcator.stage_addition(self)
    end

    def delete
      Furcate.current_furcator.stage_deletion(self)
    end

    def update
      Furcate.current_furcator.stage_deletion(self)
      # apply changes to object
      Furcate.current_furcator.stage_addition(self)
    end

    def self.find(object_id)
      Furcate.current_furcator.find{ |furcateable| furcateable.object_id == object_id }
    end
    # def to_stage_name
    #   "BOOGIE"
    # end
  end
end
