# frozen_string_literal: true

require "spec_helper"

RSpec.describe "finding a common ancestor" do
  before do
    build_basic_tree
  end

  it "says there's no conflict when only one has made changes" do
    conflicts = Furcate::Merger.check_for_conflicts("first-node", "topic1")
    expect(conflicts).to be_empty
  end

  it "says there's a conflict when both have made changes" do
    conflicts = Furcate::Merger.check_for_conflicts("main", "topic1")
    expect(conflicts).to be_present
  end

  it "says there's no conflict if both deleted" do
    conflicts = Furcate::Merger.check_for_conflicts("main", "topic2")
    expect(conflicts).to be_empty
  end

  it "says there's a conflict when one deletes and the other made changes" do
    conflicts = Furcate::Merger.check_for_conflicts("topic2", "topic1")
    expect(conflicts).to be_present
  end
end
