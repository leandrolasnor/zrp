# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount_devise_token_auth_for 'User', at: 'auth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: proc { [200, {}, ['success']] }

  scope '/v1' do
    resources :heroes, only: [:show, :create, :update, :delete] do
      get :list, on: :collection
    end

    get :tests, to: 'tests#test'
  end

  match '*path', via: :all, to: proc { [404, {}, nil] }
end
