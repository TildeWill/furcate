module Furcate
  class Base
    def create
      Furcate.stage_addition(self)
    end

    def delete
      Furcate.stage_deletion(self)
    end

    def update(attributes = {})
      Furcate.stage_deletion(self)
      # apply changes to object
      Furcate.stage_addition(self)
    end

    def to_stage_name
      "BOOGIE"
    end
  end
end
