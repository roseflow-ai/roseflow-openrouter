# frozen_string_literal: true

require "roseflow/types"

module Types
  StringOrArray = Types::String | Types::Array.of(Types::String)
  StringOrNil = Types::String | Types::Nil
  Reasoning = Types::Hash.schema(
    effort: Types::String,
    exclude: Types::Bool
  )
end

require_relative "open_router/version"
require_relative "open_router/client"
require_relative "open_router/config"
require_relative "open_router/model_repository"
require_relative "open_router/model"
require_relative "open_router/provider"

module Roseflow
  module OpenRouter
    class Error < StandardError; end
    class DeprecationError < StandardError; end
  end
end
