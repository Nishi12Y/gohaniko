class AnswersController < ApplicationController

  def new
    @group = Group.find_by(uuid: params[:group_uuid])
    # @question = Question.find(params[:question_id])
    @answer = Answer.new
  end
end
