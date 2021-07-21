# frozen_string_literal: true
# require "active_record"
require "furcate/version"
require "furcate/railtie" if defined?(Rails::Railtie)
require "furcate/base" if defined?(Rails::Railtie)
require "furcate/commit" if defined?(Rails::Railtie)

module Furcate
  class Error < StandardError; end
  @@staged_changes = {}

  @@tree = []
  @@parent_commit = nil
  @@references = {"main": nil}
  @@current_branch_name = "main"
  @@head = nil

  def self.staged_changes
    @@staged_changes
  end

  def self.stage_addition(furcateable)
    @@staged_changes[furcateable] = :addition
    @@tree += [furcateable]
  end

  def self.stage_deletion(furcateable)
    @@staged_changes[furcateable] = :deletion
    @@tree -= [furcateable]
  end

  def self.commit(message = "")
    new_commit = Commit.new(message, parent_commit, tree.dup)
    @@parent_commit = new_commit
    @@staged_changes = {}
    @@references[@@current_branch_name] = new_commit
    @@head = new_commit
  end

  def self.tree
    @@tree
  end

  def self.parent_commit
    @@parent_commit
  end

  def self.create_and_switch_to_branch(branch_name)
    @@references[branch_name] = @@head
    @@current_branch_name = branch_name
  end

  def self.switch_to_branch(branch_name)
    @@head = @@references[branch_name]
    @@tree = @@head.tree
    @@current_branch_name = branch_name
  end

  def self.merge_branch_in_to_current(source_branch_name, message = "")
    destination_branch_name = @@current_branch_name
    new_commit = Commit.new(message, @@references[destination_branch_name], @@references[source_branch_name].tree.clone)
    @@parent_commit = new_commit
    @@staged_changes = {}
    @@references[@@current_branch_name] = new_commit
    @@head = new_commit
    @@tree = new_commit.tree
  end
end
