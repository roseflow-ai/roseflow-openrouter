# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "roseflow/open_router/config"
require "roseflow/open_router/model"

FARADAY_RETRY_OPTIONS = {
  max: 3,
  interval: 0.05,
  interval_randomness: 0.5,
  backoff_factor: 2,
}

module Roseflow
  module OpenRouter
    class Client
      def initialize(config = Config.new, provider = nil)
        @config = config
        @provider = provider
      end

      def models
        response = connection.get("/api/v1/models")
        body = JSON.parse(response.body)
        body.fetch("data", []).map do |model|
          OpenRouter::Model.new(model, self)
        end
      end

      def completion(model:, prompt:, **options)
        connection.post("/api/v1/chat/completions") do |request|
          request.body = options.merge({
            model: model.name,
            messages: prompt,
          })
        end
      end

      def streaming_completion(model:, prompt:, **options, &block)
        streamed = []
        raw_ = !!options.delete(:raw)
        options.delete(:streaming)

        connection.post("/api/v1/chat/completions") do |request|
          request.body = options.merge({
            model: model.name,
            messages: prompt,
            stream: true,
          })

          request.options.on_data = Proc.new do |chunk|
            if block_given?
              yield streaming_chunk(chunk) unless raw_
              yield chunk if raw_
            end

            streamed << chunk unless block_given?
          end
        end

        streamed unless block_given?
      end

      private

      attr_reader :config, :provider

      def connection
        @connection ||= Faraday.new(
          url: Config::OPENROUTER_API_URL,
          headers: {
            "HTTP-Referer": config.referer,
          },
        ) do |faraday|
          faraday.request :authorization, "Bearer", -> { config.api_key }
          faraday.request :json
          faraday.request :retry, FARADAY_RETRY_OPTIONS
          faraday.adapter Faraday.default_adapter
        end
      end

      def streaming_chunk(chunk)
        return chunk unless chunk.match(/{.*}/)

        chunk.scan(/{.*}/).map do |json|
          JSON.parse(json).dig("choices", 0, "delta", "content")
        end.join("")
      end
    end
  end
end
