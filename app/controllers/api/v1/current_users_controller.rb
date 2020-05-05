class Api::V1::CurrentUsersController < Api::ApiController
    def update
        @user = current_or_guest_user
        if @user.update update_params
            head :ok
        else
            render_errors_for @user
        end
    end

    def update_params
        params.require(:current_user).permit(:name)
    end
end
