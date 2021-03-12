class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[edit update destroy]
  before_action :find_question, only: :create


  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def edit; end

  def update
    @answer.update(answer_params)
    if @answer.save
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer deleted.'
    else
      redirect_to @answer.question, notice: 'Permission denied.'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
