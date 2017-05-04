class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  scope :recent, ->{order created_at: :desc}

  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, t("warning_over_size")
    end
  end
end
