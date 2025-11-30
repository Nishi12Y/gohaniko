class VotesController < ApplicationController
  # before_action :set_user_token, only: [:new]

  def new
    @group = Group.find_by(uuid: params[:group_uuid])
    @shops = @group.shops.candidate
    current_user_token = set_user_token
    # 現在のユーザーが現在のグループで投票した内容をハッシュにして格納。
    # 未投票の場合は空のハッシュになる。
    @votes = Vote.where(group_id: @group.id, user_token: current_user_token)
               .pluck(:shop_id, :score).to_h
  end

  def create
    puts("create vote")
    @group = Group.find_by(uuid: params[:group_uuid])
    current_user_token = set_user_token
    failed_flag = false

    vote_params.each do |shop_id, score|
      puts("shop_id: #{shop_id}, score: #{score}")
      vote = Vote.find_or_initialize_by(
        shop_id: shop_id,
        group_id: @group.id,
        user_token: current_user_token
      )
      vote.score = score

      if vote.save
        puts("投票成功: shop_id: #{shop_id}, score: #{score}")
      else
        puts("投票失敗: shop_id: #{shop_id}, score: #{score}")
        failed_flag = true
        break
      end
    end

    if failed_flag
      render :new, status: :unprocessable_entity, notice: "投票に失敗しました。もう一度お試しください。"
    else
      redirect_to group_path(@group), notice: "投票しました！"
    end
  end

  private

  def set_user_token
    if cookies.signed[:user_token].present?
      return cookies.signed[:user_token]
    end
    cookies.signed[:user_token] = {
      value: SecureRandom.uuid,
      expires: 1.year.from_now,
      httponly: true,
      secure: Rails.env.production?
    }
  end

  def vote_params
    params.fetch(:votes, {})
  end
end
