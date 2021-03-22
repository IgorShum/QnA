class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[edit update destroy best]
  before_action :find_question, only: %i[create]


  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    @answer.save
  end

  def edit; end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.mark_as_best
      render 'answers/update'
    else
      redirect_to @question, notice: 'Permission denied.'
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
    params.require(:answer).permit(:body, files: [])
  end
end
