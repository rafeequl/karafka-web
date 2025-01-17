# frozen_string_literal: true

module Karafka
  module Web
    module Contracts
      # Contract to validate Web-UI configuration
      class Config < Web::Contracts::Base
        configure

        # Use the same regexp as Karafka for topics validation
        TOPIC_REGEXP = ::Karafka::Contracts::TOPIC_REGEXP

        required(:ttl) { |val| val.is_a?(Numeric) && val.positive? }

        nested(:topics) do
          required(:errors) { |val| val.is_a?(String) && TOPIC_REGEXP.match?(val) }

          nested(:consumers) do
            required(:reports) { |val| val.is_a?(String) && TOPIC_REGEXP.match?(val) }
            required(:states) { |val| val.is_a?(String) && TOPIC_REGEXP.match?(val) }
            required(:metrics) { |val| val.is_a?(String) && TOPIC_REGEXP.match?(val) }
          end
        end

        nested(:tracking) do
          # Do not report more often then every second, this could overload the system
          required(:interval) { |val| val.is_a?(Integer) && val >= 1_000 }

          nested(:consumers) do
            required(:reporter) { |val| !val.nil? }
            required(:sampler) { |val| !val.nil? }
            required(:listeners) { |val| val.is_a?(Array) }
          end

          nested(:producers) do
            required(:reporter) { |val| !val.nil? }
            required(:sampler) { |val| !val.nil? }
            required(:listeners) { |val| val.is_a?(Array) }
          end
        end

        nested(:processing) do
          required(:active) { |val| [true, false].include?(val) }
          required(:consumer_group) { |val| val.is_a?(String) && TOPIC_REGEXP.match?(val) }
          # Do not update data more often not to overload and not to generate too much data
          required(:interval) { |val| val.is_a?(Integer) && val >= 1_000 }
        end

        nested(:ui) do
          nested(:sessions) do
            required(:key) { |val| val.is_a?(String) && !val.empty? }
            required(:secret) { |val| val.is_a?(String) && val.length >= 64 }
          end

          required(:show_internal_topics) { |val| [true, false].include?(val) }
          required(:cache) { |val| !val.nil? }
          required(:per_page) { |val| val.is_a?(Integer) && val >= 1 && val <= 100 }
          required(:visibility_filter) { |val| !val.nil? }
        end
      end
    end
  end
end
