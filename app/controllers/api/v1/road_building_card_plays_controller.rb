class Api::V1::RoadBuildingCardPlaysController < Api::ApiController
    def create
        development_card = current_or_guest_user.development_cards.find(params[:development_card_id])

        road_building_card_play = RoadBuildingCardPlay.new(development_card: development_card)
        if road_building_card_play.valid?
            road_building_card_play.save!
            head :created
        else
            render_errors_for road_building_card_play
        end
    end
end
