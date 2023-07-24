# frozen_string_literal: true

require_relative "operations/completion"

module Roseflow
  module OpenRouter
    class OperationHandler
      OPERATION_CLASSES = {
        completion: Operations::Completion,
      }

      def initialize(operation, options = {})
        @operation = operation
        @options = options
      end

      def call
        operation_class.new(@options)
      end

      private

      def operation_class
        OPERATION_CLASSES.fetch(@operation) do
          raise ArgumentError, "Invalid operation: #{@operation}"
        end
      end
    end
  end
end
