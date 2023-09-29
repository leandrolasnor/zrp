# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Devise' do
  before do
    Timecop.freeze('2023-09-20 00:00:00')
  end

  after do
    Timecop.return
  end

  path '/auth/sign_in' do
    post('sign in with user') do
      tags 'Auth'
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password']
      }

      response(200, 'successful') do
        let(:user) { create(:user) }
        let(:params) do
          {
            email: user.email,
            password: user.password
          }
        end

        let(:expected_body) do
          {
            data: {
              allow_password_change: false,
              email: user.email,
              id: be_a(Integer),
              image: be_nil,
              name: user.name,
              nickname: be_nil,
              provider: "email",
              uid: user.email
            }
          }
        end

        context 'on Success' do
          run_test!
          it 'must be able to sign in' do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to match(expected_body)
          end
        end
      end
    end
  end

  path '/auth' do
    post('create a user') do
      tags 'Auth'
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: ['email', 'password', 'password_confirmation']
      }

      response(200, 'successful') do
        let(:params) do
          {
            email: 'test@qa.kill',
            password: '123456',
            password_confirmation: '123456'
          }
        end

        let(:expected_body) do
          {
            status: "success",
            data: {
              allow_password_change: false,
              email: "test@qa.kill",
              id: be_a(Integer),
              image: nil,
              name: nil,
              nickname: nil,
              provider: "email",
              uid: "test@qa.kill",
              created_at: '2023-09-20T00:00:00.000-03:00',
              updated_at: '2023-09-20T00:00:00.000-03:00'
            }
          }
        end
        context 'on Success' do
          run_test!
          it 'must be able to create a new user' do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to match(expected_body)
          end
        end
      end
    end
  end
end
