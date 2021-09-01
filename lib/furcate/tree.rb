module Furcate
  class Tree < ActiveRecord::Base
    belongs_to :commit
    belongs_to :furcate_team
  end
end
