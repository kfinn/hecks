module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
    end

    private

    def find_current_user
      if current_user = env['warden'].user
        return current_user
      elsif guest_user = User.find_by(email: request.session[:guest_user_id], guest: true)
        return guest_user
      end

      reject_unauthorized_connection
    end
  end
end
