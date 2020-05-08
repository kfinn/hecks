class Api::V1::DiscardsController < Api::ApiController
    def create
        discard_requirement = current_or_guest_user.discard_requirements.find(params[:discard_requirement_id])

        discard = discard_requirement.build_discard(discard_params)
        if discard.valid?
            discard.save!
            head :created
        else
            render_errors_for discard
        end
    end

    def discard_params
        params.require(:discard).permit(
            :brick_cards_count,
            :grain_cards_count,
            :lumber_cards_count,
            :ore_cards_count,
            :wool_cards_count
        )
    end
end
