class VotesController < ApplicationController
  # before_action :set_user_token, only: [:new]

  # 投票結果表示
  def index
    @group = Group.find_by(uuid: params[:group_uuid])
    @top_shops = @group.shops.ranked_by_votes.limit(3)
  end

  private

  # ユーザートークンの取得または生成をする関数
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
