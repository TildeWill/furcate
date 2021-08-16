# frozen_string_literal: true

class Conflict
  attr_reader :conflict_type, :object, :other_conflict_type, :other_object

  def initialize(conflict_type, object, other_conflict_type, other_object)
    @conflict_type = conflict_type
    @object = object
    @other_conflict_type = other_conflict_type
    @other_object = other_object
  end
end
