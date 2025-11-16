class ShopsController < ApplicationController

  def new
    @shop = Shop.new
    @group = Group.find_by(uuid: params[:group_uuid])
  end

  def create
    @group = Group.find_by(uuid: params[:group_uuid])
    @shop = @group.shops.build(shop_params)

    if @shop.save
      redirect_to new_group_shop_path(@group), success: "候補のお店を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shop_params
    # params.require(:shop).permit(:name, :address, :url)
    params.require(:shop).permit(:name, :address, :url).merge(group_id: params[:group_id])
  end
end
