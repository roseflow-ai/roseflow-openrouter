# frozen_string_literal: true

require "roseflow/chat/message"

module Types
  module OpenAI
    FunctionCallObject = Types::Hash
    StringOrObject = Types::String | FunctionCallObject
    StringOrArray = Types::String | Types::Array
  end
end

module Roseflow
  module OpenRouter
    class ChatMessage < Roseflow::Chat::Message
    end
  end
end
