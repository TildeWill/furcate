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
  @@commits = []
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
    new_commit = Commit.new(message, parent_commit, tree)
    @@commits << new_commit
    @@parent_commit = new_commit
    @@staged_changes = {}
  end

  def self.tree
    @@tree
  end

  def self.parent_commit
    @@parent_commit
  end
end
