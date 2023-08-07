# frozen_string_literal: true

require "dry/struct"
require "active_support/core_ext/module/delegation"

require "roseflow/types"
require "fast_jsonparser"

module Roseflow
  module OpenRouter
    class ApiResponse
      delegate :success?, :failure?, :body, to: :@response

      def initialize(response)
        @response = response
      end
    end

    class TextApiResponse < ApiResponse
      def body
        @body ||= FastJsonparser.parse(@response.body)
      end

      def choices
        body[:choices].map { |choice| Choice.new(choice) }
      end
    end

    class ChatResponse < TextApiResponse
      def response
        choices.first
      end

      alias reply response
    end

    class Choice < Dry::Struct
      transform_keys(&:to_sym)

      attribute? :text, Types::String
      attribute? :message do
        attribute :role, Types::String
        attribute :content, Types::String
      end

      attribute? :finish_reason, Types::String
      attribute? :index, Types::Integer

      def to_s
        return message.content if message
        return text if text
      end
    end # Choice

    class DataOnlyEvent < Dry::Struct
      transform_keys(&:to_sym)
    end

    class Delta < Dry::Struct
      transform_keys(&:to_sym)

      attribute :content, Types::String
    end

    class StreamingChoice < Dry::Struct
      transform_keys(&:to_sym)

      attribute :index, Types::Integer
      attribute :delta, Delta
      attribute :finish_reason, Types::StringOrNil
    end

    class StreamingDone < Dry::Struct
    end

    class StreamingData < Dry::Struct
      transform_keys(&:to_sym)

      attribute :choices, Types::Array.of(StreamingChoice)
      attribute :model, Types::String

      def self.from_chunk(data)
        return StreamingDone.new if data == "[DONE]"
        new(FastJsonparser.parse(data.strip))
      rescue StandardError => e
        puts "FAILED: #{data}"
        puts "EXCEPTION: #{e.message}"
      end
    end

    class ApiUsage < Dry::Struct
      transform_keys(&:to_sym)

      attribute :prompt_tokens, Types::Integer
      attribute? :completion_tokens, Types::Integer
      attribute :total_tokens, Types::Integer
    end # ApiUsage

    class ApiResponseBody < Dry::Struct
      transform_keys(&:to_sym)

      attribute? :id, Types::String
      attribute :object, Types::String
      attribute :created, Types::Integer
      attribute? :model, Types::String
      attribute :usage, ApiUsage
      attribute :choices, Types::Array

      def success?
        true
      end
    end # ApiResponseBody
  end
end
