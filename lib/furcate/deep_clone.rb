# frozen_string_literal: true

module Furcate
  class DeepClone
    def self.clone(object)
      Marshal.load(Marshal.dump(object))
    end
  end
end
