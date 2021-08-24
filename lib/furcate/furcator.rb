# frozen_string_literal: true

module Furcate
  class Furcator
    extend Forwardable

    attr_reader :head, :references

    def initialize
      @stage = Stage.new
      @references = { "main" => NullCommit }
      @current_limb_name = "main"
    end

    def staged_changes
      @stage.staged_changes
    end

    def commit_addition(leaf)
      @stage.add(leaf)
      make_commit
    end

    def commit_deletion(leaf)
      @stage.delete(leaf)
      make_commit
    end

    def commit_modification(leaf)
      @stage.modify(leaf)
      make_commit
    end

    def create_and_switch_to_limb(limb_name)
      @references[limb_name] = @head
      @current_limb_name = limb_name
    end

    def switch_to_limb(limb_name)
      @head = @references[limb_name]
      @current_limb_name = limb_name
    end

    def add_reference(reference_name)
      @references[reference_name] = @head
    end

    def find(furcate_id)
      @head.find(furcate_id)
    end

    private

    def make_commit
      new_commit = Commit.new(@head, @stage)
      @stage = Stage.new
      @references[@current_limb_name] = new_commit
      @head = new_commit
    end
  end
end
