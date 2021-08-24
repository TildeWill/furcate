# frozen_string_literal: true

require "spec_helper"

RSpec.describe "finding a common ancestor" do
  let(:furcator) { Furcate.current_furcator }

  before do
    Furcate.current_furcator = Furcate::Furcator.new
    leaf_class = Team
    stub_const("Leaf", leaf_class)
  end

  before do
    # A -- B -- C (main)
    #  \    \
    #   \    F    (topic2)
    #    D -- E   (topic1)

    leaf = Leaf.create(color: "green")
    @commit_a = furcator.make_commit("a")

    furcator.create_and_switch_to_limb("topic1")

    leaf.update(color: "dark green")
    @commit_d = furcator.make_commit("d")

    leaf.update(color: "erie green")
    @commit_e = furcator.make_commit("e")

    furcator.switch_to_limb("main")

    leaf.update(color: "brownish green")
    @commit_b = furcator.make_commit("b")

    furcator.create_and_switch_to_limb("topic2")

    leaf.delete
    @commit_f = furcator.make_commit("f")

    furcator.switch_to_limb("main")

    leaf.delete
    @commit_c = furcator.make_commit("c")
  end

  it "says there's no conflict when only one has made changes" do
    conflicts = Furcate::Merger.check_for_conflicts("main", "main")
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
