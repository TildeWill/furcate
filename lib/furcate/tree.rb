# frozen_string_literal: true

module Furcate
  class Tree < ActiveRecord::Base
    belongs_to :commit
    belongs_to :team
  end
end
