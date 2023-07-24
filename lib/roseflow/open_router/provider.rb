# frozen_string_literal: true

require "roseflow/open_router/client"
require "roseflow/open_router/config"
require "roseflow/open_router/model_repository"

module Roseflow
  module OpenRouter
    class Provider
      def initialize(config = Roseflow::OpenRouter::Config.new)
        @config = config
      end

      def client
        @client ||= Client.new(config, self)
      end

      def models
        @models ||= ModelRepository.new(self)
      end

      def completion(model:, prompt:, **options)
        raise DeprecationError, "This method is deprecated. Please use Model operations instead."
      end

      private

      attr_reader :config
    end
  end
end
