# frozen_string_literal: true

class HeroesController < BaseController
  permit_params :show, { permit: [:id, { hero: {} }] }
  permit_params :search, { permit: [:query, :page, :per_page, { filter: [] }, { sort: [] }] }
  permit_params :destroy, { permit: [:id, { hero: {} }] }
  permit_params :create, { required: :hero, permit: [:name, :rank, :lat, :lng] }
  permit_params :update, { expect: { hero: [:id, :name, :rank, :lat, :lng] } }

  def show
    status, content, serializer = Http::ShowHero::Service.(params)
    render json: content, status: status, serializer: serializer
  end

  def create
    status, content, serializer = Http::CreateHero::Service.(params)
    render json: content, status: status, serializer: serializer
  end

  def update
    status, content, serializer = Http::EditHero::Service.(params)
    render json: content, status: status, serializer: serializer
  end

  def search
    status, content = Http::SearchHeroes::Service.(params)
    render json: content, status: status
  end

  def destroy
    status, content, serializer = Http::DestroyHero::Service.(params)
    render json: content, status: status, serializer: serializer
  end

  def ranks
    render json: Create::Hero::Models::Hero.ranks.keys, status: :ok
  end

  def statuses
    render json: Create::Hero::Models::Hero.statuses.keys, status: :ok
  end
end
