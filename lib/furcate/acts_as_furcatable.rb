module Furcate
  module Model
    def self.included(base)
      base.extend ClassMethods
    end

    # :nodoc:
    module ClassMethods
      def acts_as_furcatable(options = {})
        # defaults = PaperTrail.config.has_paper_trail_defaults
        mixer.setup#(defaults.merge(options))
      end

      # @api public
      def mixer
        ::Furcate::ModelConfig.new(self)
      end
    end

    module InstanceMethods
      # @api public
      def mix_recorder
        ::Furcate::RecordChanges.new(self)
      end

      def readonly?
        persisted?
      end
    end
  end
end
