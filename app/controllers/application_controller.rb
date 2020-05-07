class ApplicationController < ActionController::Base
    set_callback :logging_in_user, :before, :merge_current_user_and_guest_user, if: [:current_user_present?, :guest_user_present?]

    delegate :present?, to: :current_user, prefix: true
    delegate :present?, to: :guest_user, prefix: true

    def merge_current_user_and_guest_user
        guest_user.players.update_all user_id: current_user.id
    end
end
