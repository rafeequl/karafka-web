# frozen_string_literal: true

# Extra methods for controller helpers
module ControllerHelper
  # @return [String] response body
  def body
    response.body
  end

  # @return [Karafka::Core::Configurable::Node] topics config node
  def topics_config
    ::Karafka::Web.config.topics
  end

  # @return [Rack::MockResponse] mock rack response
  def response
    last_response
  end

  # @return [String] Part of support message string to match against its presence
  def support_message
    'Please help us'
  end

  # @return [String]
  def only_pro_feature
    'This feature is available only to'
  end

  # @return [Integer] http response status
  def status
    response.status
  end

  # @return [String] breadcrumbs string part to match for presence
  def breadcrumbs
    '<ol class="breadcrumb">'
  end

  # @return [String] pagination matching string
  def pagination
    'id="pagination"'
  end

  # @return [String] no results on pagination string
  def no_meaningful_results
    'first page to get meaningful results'
  end
end
