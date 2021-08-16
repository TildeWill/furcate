# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Comparing two leaves" do
  before do
    Furcate.current_furcator = Furcate::Furcator.new
    leaf_class = Class.new(Furcate::Leaf) do
      attr_reader :color

      def initialize(id, type, color)
        @id = id
        @type = type
        @color = color
      end
    end
    stub_const("Leaf", leaf_class)
  end

  context "when the two leaves have the same id, same type, and same data" do
    it "returns 'no change'" do
      leaf = Leaf.new(1, :leaf, "green")
      other_leaf = Leaf.new(1, :leaf, "green")

      expect(leaf.diff(other_leaf)).to equal(:no_change)
    end
  end

  context "when the two leaves have the same id, same type, and different data" do
    it "returns 'no change'" do
      leaf = Leaf.new(1, :leaf, "green")
      other_leaf = Leaf.new(1, :leaf, "brown")

      expect(leaf.diff(other_leaf)).to equal(:changed)
    end
  end

  context "when the two leaves have the different ids" do
    it "returns 'no change'" do
      leaf = Leaf.new(1, :leaf, "green")
      other_leaf = Leaf.new(2, :leaf, "green")

      expect(leaf.diff(other_leaf)).to equal(:no_match)
    end
  end

  context "when the two leaves have the different types" do
    it "returns 'no change'" do
      leaf = Leaf.new(1, :leaf, "green")
      other_leaf = Leaf.new(1, :needle, "green")

      expect(leaf.diff(other_leaf)).to equal(:no_match)
    end
  end
end
