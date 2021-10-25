class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    words_list = params[:words_list]
    @words_list = mount_urls(words_list)
    render json: @words_list,
           status: :ok
  end

  private

  def mount_urls(words_list)
    words_list.each do |w|
      mount_urls(w) if w.instance_of?(Array)
    end

    first_list = Question.all.where(
      title: [:title].include?(
        words_list[0]
      )
    )

    second_list = Question.all.where(
      title: [:title].include?(
        words_list[2]
      )
    )

    first_list & second_list if words_list[1] == 'and'
    first_list | second_list if words_list[1] == 'or'
    first_list - second_list if words_list[1] == '-'
  end
end
