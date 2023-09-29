# frozen_string_literal: true

class AllocateResource::Steps::Sort
  include Dry::Monads[:result]

  def call(matches)
    matches.sort_by! { _1.score! }.reverse! # sort_by{...}.reverse is fastest
  end
end
