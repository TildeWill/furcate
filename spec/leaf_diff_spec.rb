# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Comparing two leaves" do
  before do
    Furcate.current_furcator = Furcate::Furcator.new
    leaf_class = Team
    stub_const("Leaf", leaf_class)
    different_leaf_class = Person
    stub_const("DifferentLeaf", different_leaf_class)
  end

  context "when the two leaves have the same id, same type, and same data" do
    it "returns 'no change'" do
      leaf = Leaf.new(furcate_id: 1, color: "green")
      other_leaf = Leaf.new(furcate_id: 1, color: "green")

      expect(leaf.diff(other_leaf)).to equal(:no_change)
    end
  end

  context "when the two leaves have the same id, same type, and different data" do
    it "returns 'no change'" do
      leaf = Leaf.new(furcate_id: 1, color: "green")
      other_leaf = Leaf.new(furcate_id: 1, color: "brown")

      expect(leaf.diff(other_leaf)).to equal(:changed)
    end
  end

  context "when the two leaves have the different ids" do
    it "returns 'no change'" do
      leaf = Leaf.new(furcate_id: 1, color: "green")
      other_leaf = Leaf.new(furcate_id: 2, color: "green")

      expect(leaf.diff(other_leaf)).to equal(:no_match)
    end
  end

  context "when the two leaves have the different types" do
    it "returns 'no change'" do
      leaf = Leaf.new(furcate_id: 1, color: "green")
      other_leaf = DifferentLeaf.new(furcate_id: 1, color: "green")

      expect(leaf.diff(other_leaf)).to equal(:no_match)
    end
  end
end
