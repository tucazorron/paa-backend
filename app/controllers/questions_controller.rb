# frozen_string_literal: true

class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    data_tree = params[:data_tree]
    @data_tree = mount_urls(data_tree)
    render json: @data_tree,
           status: :ok
  end

  private

  def mount_urls(data_tree)
    data_tree.each do |element|
      mount_urls(element) if element.instance_of?(Array)
    end

    get_urls_list(data_tree[0]) if data_tree[0].instance_of?(String)
    get_urls_list(data_tree[2]) if data_tree[2].instance_of?(String)

    operate_lists(data_tree[1])
  end

  def get_urls_list(word)
    Question.where(
      {
        title: {
          '$regex': word
        }
      }
    ).all
  end

  def operate_lists(operator)
    return element1.to_a & element2.to_a if operator == 'and'
    return element1.to_a | element2.to_a if operator == 'or'
    return element1.to_a - element2.to_a if operator == '-'
  end
end
