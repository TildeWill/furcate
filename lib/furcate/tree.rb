# frozen_string_literal: true

module Furcate
  class Tree
    include Enumerable

    attr_reader :leaves

    def initialize(leaves = [])
      @leaves = Array.new(leaves)
    end

    def add(leaf_to_add)
      @leaves.push(leaf_to_add).uniq!
    end

    def delete(leaf_to_delete)
      @leaves.reject!{ |leaf| leaf == leaf_to_delete }
    end

    def each(&block)
      if block_given?
        @leaves.each(&block)
      else
        to_enum(:each)
      end
    end

    def make_commit
      freeze
      @leaves.freeze
    end
  end
end
