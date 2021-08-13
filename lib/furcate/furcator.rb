# frozen_string_literal: true

module Furcate
  class Furcator
    extend Forwardable

    attr_reader :head, :references

    def initialize
      @stage = Stage.new
      @references = { "main" => nil }
      @current_limb_name = "main"
    end

    def staged_changes
      @stage.staged_changes
    end

    def stage_addition(leaf)
      @stage.add(leaf)
    end

    def stage_deletion(leaf)
      @stage.delete(leaf)
    end

    def stage_modification(leaf)
      @stage.modify(leaf)
    end

    def make_commit(message = "")
      new_commit = Commit.new(message, @head, @stage)
      @stage = Stage.new
      @references[@current_limb_name] = new_commit
      @head = new_commit
    end

    def create_and_switch_to_limb(limb_name)
      @references[limb_name] = @head
      @current_limb_name = limb_name
    end

    def switch_to_limb(limb_name)
      @head = @references[limb_name]
      @current_limb_name = limb_name
    end

    def_delegator :@head, :find
  end
end
