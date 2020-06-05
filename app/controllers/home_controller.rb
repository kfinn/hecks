class HomeController < ApplicationController
  def show
    @user = current_or_guest_user
    @game = current_or_guest_user.games.build
  end
end
