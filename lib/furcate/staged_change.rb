module Furcate
  class StagedChange
    def initialize(type, furcateable)
      @type = type
      @furcateable = furcateable
    end

    def type
      return @type
    end
  end
end
