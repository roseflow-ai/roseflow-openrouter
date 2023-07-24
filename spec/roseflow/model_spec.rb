# frozen_string_literal: true

require "spec_helper"
require "fast_jsonparser"

module Roseflow
  module OpenRouter
    RSpec.describe Model do
      let(:provider) { Roseflow::OpenRouter::Provider.new() }
      let(:model) do
        data = FastJsonparser.parse(File.read("spec/fixtures/models/gpt-3.5-turbo-16k.json"))
        Roseflow::OpenRouter::Model.new(data, provider)
      end

      describe "#call" do
        it "can be called" do
          expect(model).to respond_to(:call)
        end

        it "returns a response" do
          VCR.use_cassette("openrouter/model/call", record: :all) do
            messages = [
              { role: "system", content: "Follow user's instructions carefully." },
              { role: "user", content: "What is the meaning of life?" },
            ]

            response = model.call(:completion, { messages: messages })
            expect(response).to be_a(Faraday::Response)
          end
        end

        it "returns a response with a block" do
          VCR.use_cassette("openrouter/model/call_with_block", record: :all) do
            messages = [
              { role: "system", content: "Follow user's instructions carefully." },
              { role: "user", content: "What is the meaning of life?" },
            ]

            response = model.call(:completion, { messages: messages, stream: true }) do |chunk|
              expect(chunk).to be_a(String)
            end
          end
        end
      end

      describe "#chat" do
        it "can be called" do
          expect(model).to respond_to(:chat)
        end

        it "returns a response" do
          VCR.use_cassette("openrouter/model/chat", record: :all) do
            messages = [
              { role: "system", content: "Follow user's instructions carefully." },
              { role: "user", content: "What is the meaning of life?" },
            ]

            response = model.chat(messages)
            expect(response).to be_a(ChatResponse)

            puts response.reply
          end
        end

        it "retuns a response with a block" do
          VCR.use_cassette("openrouter/model/chat_with_block", record: :all) do
            messages = [
              { role: "system", content: "Follow user's instructions carefully." },
              { role: "user", content: "Count from one to five." },
            ]

            chunks = []
            response = model.chat(messages, stream: true) do |chunk|
              expect(chunk).to be_a(String)
            end
          end
        end
      end
    end
  end
end
