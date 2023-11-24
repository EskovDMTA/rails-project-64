# frozen_string_literal: true

class Post < ApplicationRecord
  has_one_attached :image
  has_many :post_comments, class_name: 'PostComment', dependent: :destroy
  has_many :post_likes, dependent: :destroy

  belongs_to :creator, class_name: 'User'
  belongs_to :category

  def formatted_created_at
    created_at.strftime('%d %B %Y')
  end

  def post_image
    if image.attached?
      image
    else
      'posts/post_image.JPG'
    end
  end

  def reading_time
    words_per_minute = 200

    minutes_reading = (body.split.length / words_per_minute) + 1
    minutes_reading.to_s
  end
end
