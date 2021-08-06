# frozen_string_literal: true

require "spec_helper"

RSpec.describe "finding a common ancestor" do
  before do
    # A -- B -- C (main)
    #  \    \
    #   \    F    (topic2)
    #    D -- E   (topic1)

    furcator = Furcate::Furcator.new
    @commit_a = furcator.make_commit("a")
    furcator.create_and_switch_to_limb("topic1")
    @commit_d = furcator.make_commit("d")
    @commit_e = furcator.make_commit("e")
    furcator.switch_to_limb("main")
    @commit_b = furcator.make_commit("b")
    furcator.create_and_switch_to_limb("topic2")
    @commit_f = furcator.make_commit("f")
    furcator.switch_to_limb("main")
    @commit_c = furcator.make_commit("c")
  end

  context "when two commits are the same" do
    it "returns itself" do
      expect(@commit_a.first_common_ancestor(@commit_a)).to equal(@commit_a)
    end
  end

  context "when one commit is a direct branch off the other" do
    it "returns the one that was branched from" do
      expect(@commit_d.first_common_ancestor(@commit_a)).to equal(@commit_a)
      expect(@commit_a.first_common_ancestor(@commit_d)).to equal(@commit_a)

      expect(@commit_f.first_common_ancestor(@commit_b)).to equal(@commit_b)
      expect(@commit_b.first_common_ancestor(@commit_f)).to equal(@commit_b)
    end
  end

  context "when one commit is a distant branch off the other" do
    it "returns the one that was branched from" do
      expect(@commit_e.first_common_ancestor(@commit_a)).to equal(@commit_a)
      expect(@commit_a.first_common_ancestor(@commit_e)).to equal(@commit_a)
    end
  end

  context "when there are two commits that share a common middle branch" do
    it "returns the one that was branched from" do
      expect(@commit_f.first_common_ancestor(@commit_e)).to equal(@commit_a)
      expect(@commit_e.first_common_ancestor(@commit_f)).to equal(@commit_a)
    end
  end
end
