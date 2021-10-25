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
      w = mount_urls(w) if w.instance_of?(Array)
    end

    if words_list[0].instance_of?(String)
      first_list = Question.where(
        {
          title: {
            '$regex': words_list[0]
          }
        }
      ).all
    end

    if words_list[2].instance_of?(String)
      second_list = Question.where(
        {
          title: {
            '$regex': words_list[2]
          }
        }
      ).all
    end

    puts first_list
    puts second_list

    w = first_list.to_a & second_list.to_a if words_list[1] == 'and'
    w = first_list.to_a | second_list.to_a if words_list[1] == 'or'
    w = first_list.to_a - second_list.to_a if words_list[1] == '-'

    w
  end
end
