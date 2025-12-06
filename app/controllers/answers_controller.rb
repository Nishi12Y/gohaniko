class AnswersController < ApplicationController

  def new
    @group = Group.find_by(uuid: params[:group_uuid])
    @question_list = Question.where(is_default: true)
    @answer = Answer.new
  end
end
