# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Resque::Server, at: '/jobs'

  scope '/v1' do
    resources :heroes, only: [:show, :create, :update, :destroy] do
      get :list, on: :collection
    end

    resources :threats, only: [] do
      get :historical, on: :collection
    end

    resources :metrics, only: [] do
      get :dashboard, on: :collection
    end
  end

  root to: proc { [200, {}, ['success']] }
  match '*path', via: :all, to: proc { [404, {}, nil] }
end
