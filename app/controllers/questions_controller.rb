# frozen_string_literal: true

class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @data_tree = mount_urls(params[:data_tree])
    render json: @data_tree,
           status: :ok
  end

  private

  def mount_urls(data_tree)
    data_tree.each do |element|
      mount_urls(element) if element.instance_of?(Array)
    end

    array1 = get_urls_array(data_tree[0]) if data_tree[0].instance_of?(String)
    array2 = get_urls_array(data_tree[2]) if data_tree[2].instance_of?(String)

    operate_arrays(array1, data_tree[1], array2)
  end

  def get_urls_array(word)
    Question.where(
      {
        title: {
          '$regex': word
        }
      }
    ).all
  end

  def operate_arrays(array1, operator, array2)
    return array1.to_a & array2.to_a if operator == 'and'
    return array1.to_a | array2.to_a if operator == 'or'
    return array1.to_a - array2.to_a if operator == '-'
  end
end
