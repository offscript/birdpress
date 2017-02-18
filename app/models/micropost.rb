class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true 
  validate  :word_count
  validate  :picture_size
  
  def word_count 
    return false if :content.split(" ").length > 400
  end
  
  def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
  end
  
end

