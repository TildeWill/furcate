# frozen_string_literal: true

module Furcate
  class Ancestor
    def self.first_common(rootstock, scion)
      find_ancestor(scion, scion, rootstock)
    end

    def self.find_ancestor(scion_head, scion_commit, rootstock_head)
      return rootstock_head if rootstock_head == scion_commit
      return scion_commit if rootstock_head.parent_commit == scion_commit

      if scion_commit.parent_commit.nil?
        find_ancestor(scion_head.parent_commit || scion_head, scion_head.parent_commit || scion_head,
                      rootstock_head.parent_commit)
      else
        find_ancestor(scion_head, scion_commit.parent_commit, rootstock_head)
      end
    end
  end
end
