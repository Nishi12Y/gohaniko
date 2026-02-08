class ShopVotesController < ApplicationController
  def update
    @group = Group.find_by!(uuid: params[:group_uuid])
    @shop  = @group.shops.find(params[:shop_id])

    vote = Vote.find_or_initialize_by(
      group: @group,
      shop: @shop,
      user_token: set_user_token
    )

    vote.score = vote_params[:score].to_i
    vote.save!

    @current_score = vote.score

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to group_shops_path(@group) }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:score)
  end

  def set_user_token
    if cookies.encrypted[:user_token].present?
      return cookies.encrypted[:user_token]
    end

    token = SecureRandom.uuid
    cookies.encrypted[:user_token] = {
    value: token,
    expires: 1.year.from_now,
    httponly: true, # JavaScriptからのアクセスを防止
    secure: Rails.env.production?, # HTTPS通信時のみ送信
    same_site: :lax # CSRF対策
    }

    token
  end
end