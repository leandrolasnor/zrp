# frozen_string_literal: true

module Update::Hero
  module Steps
    class Update
      def call(record:, **params)
        record.update!(params)
        record
      end
    end
  end
end
