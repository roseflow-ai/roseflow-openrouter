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
        end
      end
    end

    # Making model inference through Provider object is now deprecated.
    #
    # To Be Removed.
    describe "#completion", skip: true do
      context "default" do
      end

      context "streaming" do
        let(:model) do
          data = FastJsonparser.parse(File.read("spec/fixtures/models/gpt-3.5-turbo-16k.json"))
          Roseflow::OpenRouter::Model.new(data, provider)
        end

        it "returns a response" do
          VCR.use_cassette("openrouter/completion/streaming", record: :all) do
            messages = [
              { role: "system", content: "Follow user's instructions carefully." },
              { role: "user", content: "What is the meaning of life?" },
            ]

            provider.completion(model: model, prompt: messages, streaming: true) do |chunk|
              expect(chunk).to be_a(String)
              puts chunk
            end
          end
        end

        it "returns a raw response" do
          VCR.use_cassette("openrouter/completion/streaming/raw", record: :all) do
            messages = [
              { role: "system", content: "Follow user's instructions carefully." },
              { role: "user", content: "What is the meaning of life?" },
            ]

            provider.completion(model: model, prompt: messages, streaming: true, raw: true) do |chunk|
              expect(chunk).to be_a(String)
              puts chunk
            end
          end
        end
      end
    end
  end
end
