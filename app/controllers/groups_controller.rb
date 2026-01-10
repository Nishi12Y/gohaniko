class GroupsController < ApplicationController
    def new
        @group = Group.new
    end

    def show
        @group = Group.find_by(uuid: params[:uuid])
        @shops = @group.shops
        @votes = Vote.where(group_id: @group.id)
        @user_token = cookies.encrypted[:user_token]

        @map_api_key = ENV["Maps_API_Key"]
        @map_shops = @shops
            .where.not(lat: nil, lng: nil)
            .map { |s| { id: s.id, name: s.name, lat: s.lat.to_f, lng: s.lng.to_f, url: s.url } }
    end

    def create
        @group = Group.new(group_params)
        @group.uuid = SecureRandom.uuid[0..10]

        if @group.save
            redirect_to confirmation_group_path(@group), turbo: false, status: :see_other, success: t("作成完了")
        else
            Rails.logger.error "Group save failed: #{@group.errors.full_messages}"
            render :new, status: :unprocessable_entity
        end
    end

    def confirmation
        @group = Group.find_by(uuid: params[:uuid])

        if @group.nil?
            Rails.logger.error "Group not found with uuid: #{params[:uuid]}"
            redirect_to root_path, alert: "グループが見つかりません" and return
        end
    end

    private
    def group_params
        params.require(:group).permit(:name, :outing_schedule)
    end
end
