# frozen_string_literal: true

require "furcate"

class Person < Furcate::Leaf
  self.table_name = "people"
end
