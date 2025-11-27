class VotesController < ApplicationController
  # before_action :set_user_token, only: [:new]

  def new
    @vote = Vote.new
    @vote.user_token = set_user_token
    @group = Group.find_by(uuid: params[:group_uuid])
    @shops = @group.shops if @group
  end

  private

  def set_user_token
    return if cookies.signed[:user_token].present?

    cookies.signed[:user_token] = {
      value: SecureRandom.uuid,
      expires: 1.year.from_now,
      httponly: true,
      secure: Rails.env.production?
    }
  end
end
