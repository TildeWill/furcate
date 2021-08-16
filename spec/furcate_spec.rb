# frozen_string_literal: true

require "spec_helper"

RSpec.describe Furcate do
  let(:furcate) { Furcate.current_furcator }

  before do
    Furcate.current_furcator = Furcate::Furcator.new
    leaf_class = Class.new(Furcate::Leaf)
    stub_const("Leaf", leaf_class)
  end

  it "clears the staged changes after a commit" do
    branchable = Leaf.new
    branchable.create
    expect(furcate.staged_changes).not_to be_empty
    furcate.make_commit
    expect(furcate.staged_changes).to be_empty
  end
end
