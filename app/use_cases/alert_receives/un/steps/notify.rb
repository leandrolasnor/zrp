# frozen_string_literal: true

module AlertReceives::UN
  class Steps::Notify
    include Dry::Events::Publisher[:create_threat]

    register_event 'threat.created'
    def call(record) = record.enabled? && publish('threat.created', threat: record)
  end
end
