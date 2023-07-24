# frozen_string_literal: true

module Roseflow
  module OpenRouter
    module Operations
      class Base < Dry::Struct
        transform_keys(&:to_sym)

        def body
          to_h.except(:path)
        end
      end
    end
  end
end
