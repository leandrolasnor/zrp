# frozen_string_literal: true

class EditHero::Steps::Edit
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:hero_edited]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'hero.edited'

  option :model, type: Interface(:update), default: -> { EditHero::Model::Hero }, reader: :private

  def call(params)
    updated = model.update(params[:id], params.to_h)
    publish('hero.edited', hero: updated)
    updated
  end
end
