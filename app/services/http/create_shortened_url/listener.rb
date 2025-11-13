# frozen_string_literal: true

module Http::CreateShortenedUrl
  module Listener
    module_function

    def on_step_succeeded(e) = RES.pub CreateShortenedUrl, "CODE##{e.result[:code]}", e.result.to_json
  end
end
