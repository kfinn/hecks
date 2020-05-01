class HomeController < ApplicationController
  def get
    @user = current_or_guest_user
  end
end
