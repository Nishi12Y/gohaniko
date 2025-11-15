class GroupsController < ApplicationController
    
    def new
        @group = Group.new
    end
    
    def show
        @group = Group.find_by(uuid: params[:uuid])
    end

    def create
        @group = Group.new(group_params)
        @group.uuid = SecureRandom.uuid[0..10]
        puts(@group.uuid)

        if @group.save
            redirect_to success_group_path(@group),success: t('作成完了')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def success
        puts("success")
        puts(params[:uuid])
        @group = Group.find_by(uuid: params[:uuid])
    end

    private
    def group_params
        params.require(:group).permit(:name, :outing_schedule)
    end
end
