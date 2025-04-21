# frozen_string_literal: true

module Roseflow
  module OpenRouter
    class ModelRepository
      attr_reader :models

      delegate :each, :all, :first, :last, to: :models

      def initialize(provider)
        @provider = provider
        @models = provider.client.models
      end

      def count
        @models.size
      end

      def find(name)
        @models.select { |model| model.name == name }.first
      end
    end
  end
end
