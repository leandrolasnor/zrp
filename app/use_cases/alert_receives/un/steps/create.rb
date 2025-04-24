# frozen_string_literal: true

module AlertReceives::UN
  class Steps::Create
    extend Dry::Initializer

    option :model, type: Types::Interface(:create), default: -> { Model::Threat }, reader: :private
    def call(res) = model.connection_pool.with_connection { model.create(res.to_h) }
  end
end
