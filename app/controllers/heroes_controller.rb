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

  def list
    status, content, serializer = Http::ListHeroes::Service.(list_params)
    render json: content, status: status, each_serializer: serializer
  end

  def search
    params.permit!(:query, :limit, :offset)
    render(**Http::SearchHeroes::Service.(params))
  end

  def destroy
    status, content, serializer = Http::DestroyHero::Service.(destroy_params)
    render json: content, status: status, serializer: serializer
  end

  private

  def create_params
    params.permit(:name, :rank, :lat, :lng)
  end

  def list_params
    params.permit(:page, :per_page)
  end

  def edit_params
    params.permit(:id, :name, :rank, :lat, :lng)
  end

  def destroy_params
    params.permit(:id)
  end

  def show_params
    params.permit(:id)
  end
end
