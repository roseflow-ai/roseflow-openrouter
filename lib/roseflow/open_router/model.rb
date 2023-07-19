# frozen_string_literal: true

require "dry/struct"
require "active_support/core_ext/module/delegation"

module Types
  include Dry.Types()
end

module Roseflow
  module OpenRouter
    class Model
      attr_reader :name, :id, :context_length

      def initialize(model, provider)
        @model_ = model
        @provider_ = provider
        assign_attributes
      end

      def max_tokens
        @context_length
      end

      private

      def assign_attributes
        @name = @model_.fetch("id")
        @id = @model_.fetch("id")
        @context_length = @model_.fetch("context_length")
      end
    end
  end
end
