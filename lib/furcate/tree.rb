# frozen_string_literal: true

module Furcate
  class Tree < Array
    def initialize(array = [])
      super(array)
    end

    def diff(tree)
      Diff.new(tree - self, self - tree)
    end

    class Diff < Hash
      def initialize(additions, deletions)
        super()
        self[:additions] = additions
        self[:deletions] = deletions
      end

      def additions
        self[:additions]
      end

      def deletions
        self[:deletions]
      end

      def same?
        additions.empty? && deletions.empty?
      end
    end
  end
end
