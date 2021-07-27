# frozen_string_literal: true

require "spec_helper"

RSpec.describe Furcate do
  before do
    branchable_class = Class.new(Furcate::Base)
    stub_const("BranchableClass", branchable_class)
  end

  it "clears the staged changes after a commit" do
    branchable = BranchableClass.new
    branchable.create
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.make_commit
    expect(Furcate.staged_changes).to be_empty
  end

  it "single user scenario" do
    branchable = BranchableClass.new
    branchable.create
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.make_commit("first commit")
    expect(BranchableClass.find(branchable.object_id)).to equal(branchable)

    branchable.update
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.make_commit("make changes to branchable")
    expect(BranchableClass.find(branchable.object_id)).to equal(branchable)

    Furcate.create_and_switch_to_limb("cleanup branch")

    branchable.delete
    expect(Furcate.staged_changes[branchable]).to equal(:deletion)
    Furcate.make_commit("delete branchable")
    expect(BranchableClass.find(branchable.object_id)).to be_nil

    Furcate.switch_to_limb("main")
    expect(BranchableClass.find(branchable.object_id)).to equal(branchable)

    # Furcate.merge_limb_in_  to_current("cleanup branch")
    # expect(BranchableClass.find(branchable.object_id)).to be_nil
  end
end
