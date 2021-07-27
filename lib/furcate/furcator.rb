# frozen_string_literal: true

module Furcate
  class Furcator
    def initialize
      @staged_changes = {}

      @stage = Stage.new
      @references = { "main" => nil }
      @current_limb_name = "main"
      @head = nil
    end

    def staged_changes
      @stage.staged_changes
    end

    def stage_addition(furcateable)
      @stage.add(furcateable)
    end

    def stage_deletion(furcateable)
      @stage.delete(furcateable)
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

    def find(&block)
      @head.find(&block)
    end

    attr_reader :head, :references

    # def self.merge_limb_in_to_current(scion, message = "")
    #   rootstock = @@current_limb_name
    #   new_commit = Commit.new(message, @@references[rootstock], @@references[scion].tree.clone)
    #   @@stage = Stage.new
    #   @@references[@@current_limb_name] = new_commit
    #   @@head = new_commit
    # end
  end
end
