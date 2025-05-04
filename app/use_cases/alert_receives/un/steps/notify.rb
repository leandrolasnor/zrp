# frozen_string_literal: true

module AlertReceives::UN
  class Steps::Notify
    def call(threat)
      AppEvents.publish('threat.created', threat:) if threat.enabled?
    end
  end
end
