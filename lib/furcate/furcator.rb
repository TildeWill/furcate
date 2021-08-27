# frozen_string_literal: true

module Furcate
  class Furcator
    extend Forwardable

    attr_reader :head, :references

    def initialize
      @references = { "main" => NullCommit }
      @current_limb_name = "main"
    end

    def create_and_switch_to_limb(limb_name)
      references[limb_name] = head
      @current_limb_name = limb_name
    end

    def switch_to_limb(limb_name)
      @head = references[limb_name]
      @current_limb_name = limb_name
    end

    def add_reference(reference_name)
      references[reference_name] = head
    end

    def find(furcate_id)
      head.find(furcate_id)
    end

    def make_commit(change)
      leaves = LeafBuilder.graft(head, change)
      new_commit = Commit.new(parent_commit: head, leaves: leaves)
      references[@current_limb_name] = new_commit
      @head = new_commit
    end
  end
end
