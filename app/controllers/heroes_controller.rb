# frozen_string_literal: true

class HeroesController < BaseController
  def show
    status, content, serializer = Http::ShowHero::Service.(show_params)
    render json: content, status: status, serializer: serializer
  end

  def create
    status, content, serializer = Http::CreateHero::Service.(create_params)
    render json: content, status: status, serializer: serializer
  end

  def update
    status, content, serializer = Http::EditHero::Service.(edit_params)
    render json: content, status: status, serializer: serializer
  end

  def search
    status, content = Http::SearchHeroes::Service.(search_params)
    render json: content, status: status
  end

  def destroy
    status, content, serializer = Http::DestroyHero::Service.(destroy_params)
    render json: content, status: status, serializer: serializer
  end

  def ranks
    render json: Create::Hero::Models::Hero.ranks.keys, status: :ok
  end

  def statuses
    render json: Create::Hero::Models::Hero.statuses.keys, status: :ok
  end

  private

  def create_params
    params.required(:hero).permit(
      :name, :rank,
      :lat, :lng
    )
  end

  def list_params
    params.permit(:page, :per_page)
  end

  def search_params
    params.permit(
      :query,
      :page, :per_page,
      filter: [], sort: []
    )
  end

  def edit_params
    params.expect(
      hero: [
        :id, :name, :rank,
        :lat, :lng
      ]
    )
  end

  def destroy_params
    params.permit(:id, hero: {})
  end

  def show_params
    params.permit(:id, hero: {})
  end
end
