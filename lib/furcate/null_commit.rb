# frozen_string_literal: true

module Furcate
  class NullCommit < Commit
    def leaves
      []
    end
  end
end
