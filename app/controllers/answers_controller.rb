class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create new destroy]
  before_action :find_answer, only: %i[show edit update destroy]
  before_action :find_question, only: %i[new create]

  def show; end

  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    @answer.save
    redirect_to @question
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
    if check_user
      @answer.destroy
      redirect_to root_path
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

  def check_user
    current_user.author_of?(@answer)
  end
end
