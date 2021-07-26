require "spec_helper"

RSpec.describe Furcate do
  Branchable = Class.new(Furcate::Base)

  it "clears the staged changes after a commit" do
    branchable = Branchable.new
    branchable.create
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.make_commit
    expect(Furcate.staged_changes).to be_empty
  end

  it "single user scenario" do
    branchable = Branchable.new
    branchable.create
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.make_commit("first commit")
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    branchable.update
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.make_commit("make changes to branchable")
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    Furcate.create_and_switch_to_limb("cleanup branch")

    branchable.delete
    expect(Furcate.staged_changes[branchable]).to equal(:deletion)
    Furcate.make_commit("delete branchable")
    expect(Branchable.find(branchable.object_id)).to be_nil

    Furcate.switch_to_limb("main")
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    # Furcate.merge_limb_in_to_current("cleanup branch")
    # expect(Branchable.find(branchable.object_id)).to be_nil
  end
end
