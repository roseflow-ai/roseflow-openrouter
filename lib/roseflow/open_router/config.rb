# frozen_string_literal: true

require "anyway_config"

module Roseflow
  module OpenRouter
    class Config < Anyway::Config
      config_name :openrouter

      attr_config :api_key
      attr_config :referer

      required :api_key
      required :referer

      OPENROUTER_API_URL = "https://openrouter.ai/api/v1".freeze
    end
  end
end
