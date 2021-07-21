require "active_record"
require_relative "acts_as_furcatable"

ActiveRecord::Base.include Furcate::Model
