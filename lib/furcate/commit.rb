module Furcate
  class Commit
    attr_reader :message, :parent_commit, :tree
    def initialize(message, parent_commit, tree)
      @message = message
      @parent_commit = parent_commit
      @tree = tree
    end
  end
end
