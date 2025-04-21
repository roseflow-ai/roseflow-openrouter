# frozen_string_literal: true

require "spec_helper"
require "roseflow/open_router/config"
require "fast_jsonparser"

Anyway::Settings.use_local_files = true
provider_config = Roseflow::OpenRouter::Config.new

VCR.configure do |config|
  config.filter_sensitive_data("<OPENROUTER_API_KEY>") { provider_config.api_key }
end

module Roseflow
  RSpec.describe OpenRouter do
    it "has a version number" do
      expect(Roseflow::OpenRouter.gem_version).not_to be nil
    end

    let(:provider) { Roseflow::OpenRouter::Provider.new() }

    describe "#models" do
      it "returns a list of models" do
        VCR.use_cassette("openrouter/models", record: :all) do
          expect(provider.models).to be_a(Roseflow::OpenRouter::ModelRepository)
          expect(provider.models.count).to be > 0
          expect(provider.models.first).to be_a(Roseflow::OpenRouter::Model)
          puts "Model name: #{provider.models.first.name}"
          puts "Model description: #{provider.models.first.description}"
          puts "Model architecture: #{provider.models.first.architecture}"
        end
      end
    end
  end
end
