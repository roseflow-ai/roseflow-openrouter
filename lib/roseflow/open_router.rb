# frozen_string_literal: true

require "roseflow/types"
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
