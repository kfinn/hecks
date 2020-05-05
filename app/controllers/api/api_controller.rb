class Api::ApiController < ActionController::Base
    def render_errors_for(model)
        render status: :unprocessable_entity, partial: 'errors/errors', locals: { errors: model.errors }
    end
end
