# frozen_string_literal: true

module AlertReceives::UN
  class Contract < ApplicationContract
    params do
      required(:monsterName).filled(:string)
      required(:dangerLevel).filled(:string).value(included_in?: Model::Threat.ranks.keys.map(&:camelcase))
      required(:location).schema do
        required(:lat).filled(:float)
        required(:lng).filled(:float)
      end
    end

    rule do
      values[:payload] = values.data.to_json
    end

    rule :monsterName do
      values[:name] = values.delete :monsterName
    end

    rule :dangerLevel do
      values[:rank] = values.delete(:dangerLevel).downcase
    end

    rule location: [:lat, :lng] do
      values[:lat] = values[:location][:lat]
      values[:lng] = values[:location][:lng]
      values.delete :location
    end
  end
end
