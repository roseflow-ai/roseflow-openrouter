# frozen_string_literal: true

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
        streaming = options.fetch(:streaming, false)

        if streaming
          client.streaming_completion(model: model, prompt: prompt, **options)
        else
          client.completion(model: model, prompt: prompt, **options)
        end
      end

      private

      attr_reader :config
    end
  end
end
