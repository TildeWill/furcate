# frozen_string_literal: true

module Furcate
  class Commit
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

      def empty?
        additions.empty? && deletions.empty?
      end

      def same?
        empty?
      end
    end
  end
end
