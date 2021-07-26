module Furcate
  class Commit
    attr_reader :message, :parent_commit, :tree
    def initialize(message, parent_commit, stage)
      @message = message
      @parent_commit = parent_commit
      previous_tree = parent_commit ? Marshal.load(Marshal.dump(parent_commit.tree)) : Tree.new
      @tree = build_new_tree(previous_tree, stage)
      @tree.make_commit
    end

    def find(&block)
      @tree.find(&block)
    end

    private
    def build_new_tree(tree, stage)
      #add the additions from the staged tree
      stage.additions.each do |change|
        tree.add(change)
      end

      stage.deletions.each do |change|
        tree.delete(change)
      end

      tree
    end
  end
end
