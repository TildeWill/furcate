# frozen_string_literal: true

require "spec_helper"

RSpec.describe "finding a common ancestor" do
  before do
    build_basic_tree
    @commit_a = Furcate.current_furcator.references["A"]
    @commit_b = Furcate.current_furcator.references["B"]
    @commit_c = Furcate.current_furcator.references["C"]
    @commit_d = Furcate.current_furcator.references["D"]
    @commit_e = Furcate.current_furcator.references["E"]
    @commit_f = Furcate.current_furcator.references["F"]
  end

  context "when two commits are the same" do
    it "returns itself" do
      expect(Furcate::Ancestor.first_common(@commit_a, @commit_a)).to equal(@commit_a)
    end
  end

  context "when one commit is a direct branch off the other" do
    it "returns the one that was branched from" do
      expect(Furcate::Ancestor.first_common(@commit_d, @commit_a)).to equal(@commit_a)
      expect(Furcate::Ancestor.first_common(@commit_a, @commit_d)).to equal(@commit_a)

      expect(Furcate::Ancestor.first_common(@commit_f, @commit_b)).to equal(@commit_b)
      expect(Furcate::Ancestor.first_common(@commit_b, @commit_f)).to equal(@commit_b)
    end
  end

  context "when one commit is a distant branch off the other" do
    it "returns the one that was branched from" do
      expect(Furcate::Ancestor.first_common(@commit_e, @commit_a)).to equal(@commit_a)
      expect(Furcate::Ancestor.first_common(@commit_a, @commit_e)).to equal(@commit_a)
    end
  end

  context "when there are two commits that share a common ancestor limb" do
    it "returns the commit that was branched from (aka 'the crotch')" do
      expect(Furcate::Ancestor.first_common(@commit_f, @commit_e)).to equal(@commit_a)
      expect(Furcate::Ancestor.first_common(@commit_e, @commit_f)).to equal(@commit_a)
    end
  end
end
