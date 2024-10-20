# frozen_string_literal: true

module AlertReceives::UN
  class Transaction
    include Dry::Transaction(container: Container)

    step :validate, with: 'steps.validate'
    map :create, with: 'steps.create'
    tee :notify, with: 'steps.notify'
  end
end
