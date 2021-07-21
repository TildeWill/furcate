require "spec_helper"

RSpec.describe Furcate do
  Branchable = Class.new(Furcate::Base)
  it "has a version number" do
    expect(Furcate::VERSION).not_to be nil
  end

  it "single user scenario" do
    expect(Furcate.tree).to be_empty
    branchable = Branchable.new
    branchable.create
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.commit
    expect(Furcate.staged_changes).to be_empty
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    branchable.update
    expect(Furcate.staged_changes[branchable]).to equal(:addition)
    Furcate.commit
    expect(Furcate.staged_changes).to be_empty
    expect(Branchable.find(branchable.object_id)).to equal(branchable)

    branchable.delete
    expect(Furcate.staged_changes[branchable]).to equal(:deletion)
    Furcate.commit
    expect(Furcate.staged_changes).to be_empty
    expect(Branchable.find(branchable.object_id)).to be_nil
  end
end
