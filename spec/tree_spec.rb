# frozen_string_literal: true

require "spec_helper"

RSpec.describe Furcate::Tree do
  it "compares two empty trees" do
    diff = Furcate::Tree.new.diff(Furcate::Tree.new)
    expect(diff).to be_same
  end

  it "compares a tree with one thing to an empty tree" do
    diff = Furcate::Tree.new(["foo"]).diff(Furcate::Tree.new)
    expect(diff).not_to be_same
    expect(diff.additions).to be_empty
    expect(diff.deletions).to match_array(["foo"])
  end

  it "compares an empty tree to a tree with one thing" do
    diff = Furcate::Tree.new.diff(Furcate::Tree.new(["foo"]))
    expect(diff).not_to be_same
    expect(diff.additions).to match_array(["foo"])
    expect(diff.deletions).to be_empty
  end

  it "compares a tree with one thing to a tree with the same thing" do
    diff = Furcate::Tree.new(["foo"]).diff(Furcate::Tree.new(["foo"]))
    expect(diff).to be_same
    expect(diff.additions).to be_empty
    expect(diff.deletions).to be_empty
  end
end
