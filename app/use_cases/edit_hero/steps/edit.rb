# frozen_string_literal: true

class EditHero::Steps::Edit
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:hero_edited]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'hero.edited'

  option :hero, type: Interface(:update), default: -> { EditHero::Model::Hero }, reader: :private

  def call(params)
    updated = ApplicationRecord.transaction do
      record = hero.lock.find(params[:id])
      record.update!(params.to_h.except(:id))
      record
    end
    publish('hero.edited', hero: updated)
    updated
  end
end
