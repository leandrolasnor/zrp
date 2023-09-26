# frozen_string_literal: true

module ::Auth
  module Helper
    def auth_token
      @auth_token ||= FactoryBot.create(:user).create_new_auth_token
    end
  end
end
