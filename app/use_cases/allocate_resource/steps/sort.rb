# frozen_string_literal: true

class AllocateResource::Steps::Sort
  include Dry::Monads[:result]

  # sort_by{...}.reverse is fastest
  def call(matches) = matches.sort_by!(&:score!).reverse!
end
