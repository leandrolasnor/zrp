module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :token

    def connect
      self.token = 'token'
    end
  end
end
