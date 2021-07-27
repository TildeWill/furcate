# frozen_string_literal: true

require "furcate/version"
require "furcate/base"
require "furcate/commit"
require "furcate/stage"

module Furcate
  @@staged_changes = {}

  @@stage = Stage.new
  @@references = { "main" => nil }
  @@current_limb_name = "main"
  @@head = nil

  def self.staged_changes
    @@stage.staged_changes
  end

  def self.stage_addition(furcateable)
    @@stage.add(furcateable)
  end

  def self.stage_deletion(furcateable)
    @@stage.delete(furcateable)
  end

  def self.make_commit(message = "")
    new_commit = Commit.new(message, @@head, @@stage)
    @@stage = Stage.new
    @@references[@@current_limb_name] = new_commit
    @@head = new_commit
  end

  def self.create_and_switch_to_limb(limb_name)
    @@references[limb_name] = @@head
    @@current_limb_name = limb_name
  end

  def self.switch_to_limb(limb_name)
    @@head = @@references[limb_name]
    @@current_limb_name = limb_name
  end

  def self.find(&block)
    @@head.find(&block)
  end

  def self.head
    @@head
  end

  def self.references
    @@references
  end

  # def self.merge_limb_in_to_current(scion, message = "")
  #   rootstock = @@current_limb_name
  #   new_commit = Commit.new(message, @@references[rootstock], @@references[scion].tree.clone)
  #   @@stage = Stage.new
  #   @@references[@@current_limb_name] = new_commit
  #   @@head = new_commit
  # end
end
