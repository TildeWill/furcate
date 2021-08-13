# frozen_string_literal: true

module Furcate
  class Merger
    def self.check_for_conflicts(rootstock, scion)
      common_ancestor = rootstock.first_common_ancestor(scion)
      root_diff = CommitDiff.diff(rootstock, common_ancestor)
      scion_diff = CommitDiff.diff(scion, common_ancestor)

      CommitConflicts.calculate_conflicts(root_diff, scion_diff)
    end

    def do_merge(resolved_conflicts)
      # apply entire scion limb on to rootstock
      # apply resolved conflicts
      # commit?
    end
  end
end
