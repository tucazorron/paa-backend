# frozen_string_literal: true

class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :url, type: String
  field :body, type: String
end
