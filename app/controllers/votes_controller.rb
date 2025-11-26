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
    session[:user_token] ||= SecureRandom.uuid
    cookies.permanent.signed[:user_token] = session[:user_token]
    session[:user_token]
  end
end
