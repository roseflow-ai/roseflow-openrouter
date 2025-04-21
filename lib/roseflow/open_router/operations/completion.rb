# frozen_string_literal: true

require_relative "base"
require "roseflow/open_router/chat_message"

module Roseflow
  module OpenRouter
    module Operations
      # Chat operation.
      #
      # Given a list of messages comprising a conversation, the model will
      # return a response.
      #
      # See https://openrouter.ai/docs for more information.
      #
      # The OpenRouter API is compatible with OpenAI Chat API. See
      # https://platform.openai.com/docs/api-reference/chat/create for more.
      class Completion < Base
        attribute? :model, Types::String
        attribute? :models, Types::String
        attribute? :provider, Types::Hash.schema(
          sort: Types::String
        )
        attribute :messages, Types::Array.of(ChatMessage)
        attribute? :usage, Types::Hash.schema(
          include: Types::Bool
        )
        attribute? :functions, Types::Array.of(Types::Hash)
        attribute? :function_call, Types::String
        attribute? :reasoning, Types::Reasoning
        attribute? :transforms, Types::Array.of(Types::String)
        attribute? :temperature, Types::Float.default(1.0)
        attribute? :seed, Types::Integer
        attribute? :top_p, Types::Float.default(1.0)
        attribute? :top_k, Types::Integer
        attribute? :top_a, Types::Float
        attribute? :min_p, Types::Float
        attribute? :top_logprobs, Types::Integer
        attribute :stream, Types::Bool.default(false)
        attribute? :max_tokens, Types::Integer
        attribute? :presence_penalty, Types::Number.default(0)
        attribute? :frequency_penalty, Types::Number.default(0)
        attribute? :user, Types::String

        # attribute :n, Types::Integer.default(1)
        # attribute? :stop, Types::StringOrArray

        attribute :path, Types::String.default("/api/v1/chat/completions")
      end
    end
  end
end
