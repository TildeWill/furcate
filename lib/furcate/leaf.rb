# frozen_string_literal: true

require "active_record"

module Furcate
  class Leaf
    extend Forwardable

    def_delegator :@record, :attributes

    def self.inherited(klass)
      raise Furcate::AnonymousClassNotSupported if (namespaced_name = klass.name).nil?

      class_parts = namespaced_name.split("::")
      class_parts << "Furcate#{class_parts.pop}"
      record_class_string = class_parts.join("::")
      record_class = Class.new(ActiveRecord::Base)
      method_string = <<-RUBY
        def self.name
          "#{record_class_string}"
        end
      RUBY
      record_class.class_eval(method_string)

      klass.define_method :record_class do
        record_class
      end

      Object.const_set(record_class_string, record_class)
      super
    end

    def type
      record_class.name
    end

    def id
      @record.furcate_id
    end

    def initialize(attributes = {})
      @record = record_class.new(attributes)
    end

    def self.create(attributes = {})
      leaf = new(attributes)
      leaf.instance_variable_get("@record").save
      change = Change.new(leaf, :addition)
      Furcate.current_furcator.make_commit(change)
      leaf
    end

    def delete
      change = Change.new(self, :deletion)
      Furcate.current_furcator.make_commit(change)
    end

    def update(attributes = {})
      @record = record_class.new(self.attributes.except("id").merge(attributes))
      @record.save
      change = Change.new(self, :modification)
      Furcate.current_furcator.make_commit(change)
    end

    def self.find(furcate_id)
      Furcate.current_furcator.find(furcate_id)
    end

    def diff(other_leaf)
      return :no_match unless id == other_leaf.id && type == other_leaf.type
      return :changed unless Marshal.dump(self) == Marshal.dump(other_leaf)

      :no_change
    end
  end
end
