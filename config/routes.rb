# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Resque::Server, at: '/jobs'

  scope '/v1' do
    resources :heroes, only: [:show, :create, :update, :destroy] do
      get :search, on: :collection
      get :ranks, on: :collection
      get :statuses, on: :collection
    end

    resources :threats, only: [] do
      get :historical, on: :collection
      post :set_insurgency, on: :collection
    end

    resources :shortened_urls, only: :create do
      get '/:code', to: 'shortened_urls#redirect', as: :short_redirect
    end
  end

  get :up, to: "rails/health#show", as: :rails_health_check
  root to: "rails/health#show"
  match '*path', to: proc { [404, {}, []] }, via: :all
end
