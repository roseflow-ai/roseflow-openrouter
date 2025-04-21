# frozen_string_literal: true

require "dry/struct"
require "active_support/core_ext/module/delegation"

require "roseflow/open_router/operation_handler"
require "roseflow/open_router/response"

module Types
  include Dry.Types()
end

module Roseflow
  module OpenRouter
    class Model
      attr_reader :name, :id, :context_length, :description, :architecture, :pricing

      def initialize(model, provider)
        @model_ = model
        @provider_ = provider
        assign_attributes
      end

      def max_tokens
        @context_length
      end

      # Convenience method for chat completions.
      #
      # @param messages [Array<String>] Messages to use
      # @param options [Hash] Options to use
      # @yield [chunk] Chunk of data if stream is enabled
      # @return [OpenAI::ChatResponse] the chat response object if no block is given
      def chat(messages, options = {}, &block)
        response = call(:completion, options.merge({ messages: messages, model: name }), &block)
        ChatResponse.new(response) unless block_given?
      end

      # Calls the model.
      #
      # @param operation [Symbol] Operation to perform
      # @param options [Hash] Options to use
      # @yield [chunk] Chunk of data if stream is enabled
      # @return [Faraday::Response] raw API response if no block is given
      def call(operation, options, &block)
        operation = OperationHandler.new(operation, options.merge({ model: name })).call
        client.post(operation, &block)
      end

      private

      attr_reader :provider_

      def assign_attributes
        @name = @model_.fetch(:id)
        @id = @model_.fetch(:id)
        @context_length = @model_.fetch(:context_length)
        @description = @model_.fetch(:description)
        @architecture = @model_.fetch(:architecture)
        @pricing = @model_.fetch(:pricing)
      end

      def client
        provider_.client
      end
    end
  end
end
