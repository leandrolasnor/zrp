# frozen_string_literal: true

module Http::DestroyHero
  module Listener
    module_function

    def on_step_succeeded(e) = RemoveFromIndex::Job.perform_later(e.payload)
  end
end
