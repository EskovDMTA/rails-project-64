# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar
  has_many :comments, class_name: 'PostComment', dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :posts, foreign_key: 'creator_id', class_name: 'Post', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :avatar_size_validation, if: -> { avatar.attached? }
  validates :profession, length: { maximum: 20 }, allow_blank: true

  def avatar_size_validation
    return unless avatar.attached? && avatar.blob.byte_size > 10.megabytes

    errors.add(:avatar, 'should be less than 10MB')
  end

  def post_avatar
    if avatar.attached?
      avatar.variant(resize: '100x100').processed
    else
      'posts/default_avatar.png'
    end
  rescue StandardError
    'posts/default_avatar.png'
  end

  def comment_avatar
    if avatar.attached?
      avatar.variant(resize: '30x30').processed
    else
      'posts/default_avatar.png'.variant(resize: '30x30').processed
    end
  end
end
