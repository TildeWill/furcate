require "spec_helper"

RSpec.describe Furcate do
  Branchable = Class.new(Furcate::Base)

  it "clears the staged changes after a commit" do
    branchable = Branchable.new
    branchable.create
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.commit
    expect(Furcate.staged_changes).to be_empty
  end

  it "single user scenario" do
    branchable = Branchable.new
    branchable.create
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.commit
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    branchable.update
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.commit
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    Furcate.create_and_switch_to_branch("cleanup branch")

    branchable.delete
    expect(Furcate.staged_changes[branchable]).to equal(:deletion)
    Furcate.commit
    expect(Branchable.find(branchable.object_id)).to be_nil

    Furcate.switch_to_branch("main")
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    Furcate.merge_branch_in_to_current("cleanup branch")
    expect(Branchable.find(branchable.object_id)).to be_nil
  end
end
