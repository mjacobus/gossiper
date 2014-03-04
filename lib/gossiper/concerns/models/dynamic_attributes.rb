module Gossiper
  module Concerns
    module Models
      module DynamicAttributes
        extend ActiveSupport::Concern

        included do
          serialize :dynamic_attributes, JSON
        end

        module ClassMethods
          def dynamic_attributes(*args)
            args.each do |method|

              # dynamic getters
              define_method method do
                dynamic_attribute_get(method)
              end

              # dynamic setters
              define_method "#{method}=" do |value|
                dynamic_attribute_set(method, value)
              end
            end
          end
        end

        def dynamic_attribute_set(name, value)
          self.dynamic_attributes = dynamic_attributes.merge({ name.to_s => value })
        end

        def dynamic_attribute_get(name)
          self.dynamic_attributes[name.to_s]
        end

        def dynamic_attributes
          read_attribute(:dynamic_attributes).presence || {}
        end

      end
    end
  end
end
