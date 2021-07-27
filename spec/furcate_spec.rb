# frozen_string_literal: true

require "spec_helper"

RSpec.describe Furcate do
  let(:furcate) { Furcate.current_furcator }

  before do
    Furcate.current_furcator = Furcate::Furcator.new
    branchable_class = Class.new(Furcate::Base)
    stub_const("BranchableClass", branchable_class)
  end

  it "clears the staged changes after a commit" do
    branchable = BranchableClass.new
    branchable.create
    expect(furcate.staged_changes).not_to be_empty
    furcate.make_commit
    expect(furcate.staged_changes).to be_empty
  end

  it "single user scenario" do
    branchable = BranchableClass.new
    branchable.create
    expect(furcate.staged_changes[branchable]).to equal(:addition)
    furcate.make_commit("first commit")
    expect(BranchableClass.find(branchable.object_id)).to equal(branchable)

    branchable.update
    expect(furcate.staged_changes[branchable]).to equal(:addition)
    furcate.make_commit("make changes to branchable")
    expect(BranchableClass.find(branchable.object_id)).to equal(branchable)

    furcate.create_and_switch_to_limb("cleanup branch")

    branchable.delete
    expect(furcate.staged_changes[branchable]).to equal(:deletion)
    furcate.make_commit("delete branchable")
    expect(BranchableClass.find(branchable.object_id)).to be_nil

    furcate.switch_to_limb("main")
    expect(BranchableClass.find(branchable.object_id)).to equal(branchable)

    # furcate.merge_limb_in_  to_current("cleanup branch")
    # expect(BranchableClass.find(branchable.object_id)).to be_nil
  end
end
