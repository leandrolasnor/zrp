# frozen_string_literal: true

class CreateThreat::Monad
  include Dry::Monads[:result, :try]
  include Dry::Events::Publisher[:create_threat]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'threat.created'

  option :model, type: Interface(:create), default: -> { CreateThreat::Model::Threat }, reader: :private

  def call(params)
    Try do
      record = model.connection_pool.with_connection do
        model.create do
          _1.name = params[:monsterName] rescue nil
          _1.rank = params[:dangerLevel].downcase rescue nil
          _1.lat = params[:location].first[:lat] rescue nil
          _1.lng = params[:location].first[:lng] rescue nil
          _1.status = CreateThreat::Model::Threat.statuses['problem'] unless (params[:location].first[:lng] rescue nil) &&
                                                                             (params[:location].first[:lat] rescue nil) &&
                                                                             params[:monsterName] &&
                                                                             params[:dangerLevel]

          _1.payload = params.to_json
        end
      end
      publish('threat.created', threat: record) if record.enabled?
      record
    end
  end
end
