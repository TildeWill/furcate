# frozen_string_literal: true

require "spec_helper"

RSpec.describe Furcate::Commit do
  let(:commit) { Furcate::Commit.new(nil, nil, stage) }
  let(:other_commit) { Furcate::Commit.new(nil, nil, other_stage) }

  context "when comparing two commits with no data" do
    let(:stage) { Furcate::Stage.new }
    let(:other_stage) { Furcate::Stage.new }

    it "says the commits are the same" do
      diff = commit.diff(other_commit)
      expect(diff).to be_same
    end
  end

  context "when comparing a commit with one thing to an empty commit" do
    let(:stage) { Furcate::Stage.new(["foo"]) }
    let(:other_stage) { Furcate::Stage.new }

    it "supplies what's been deleted" do
      diff = commit.diff(other_commit)
      expect(diff).not_to be_same
      expect(diff.additions).to be_empty
      expect(diff.deletions).to match_array(["foo"])
    end
  end

  context "when comparing an empty commit to a commit with one thing" do
    let(:stage) { Furcate::Stage.new }
    let(:other_stage) { Furcate::Stage.new(["foo"]) }

    it "supplies what's been added" do
      diff = commit.diff(other_commit)
      expect(diff).not_to be_same
      expect(diff.additions).to match_array(["foo"])
      expect(diff.deletions).to be_empty
    end
  end

  context "when comparing a commit with one thing to a commit with the same thing" do
    let(:stage) { Furcate::Stage.new(["foo"]) }
    let(:other_stage) { Furcate::Stage.new(["foo"]) }

    it "says the commits are the same" do
      diff = commit.diff(other_commit)
      expect(diff).to be_same
      expect(diff.additions).to be_empty
      expect(diff.deletions).to be_empty
    end
  end

  context "when comparing a commit with two of one thing to a commit with one of the same thing",
          skip: "not sure if we need this behavior, values might be unique" do
    let(:stage) { Furcate::Stage.new(%w[foo foo]) }
    let(:other_stage) { Furcate::Stage.new(["foo"]) }

    it "shows the deletion of one thing" do
      diff = commit.diff(other_commit)
      expect(diff).to be_same
      expect(diff.additions).to be_empty
      expect(diff.deletions).to match_array(["foo"])
    end
  end
end
