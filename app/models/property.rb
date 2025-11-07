class Property < ApplicationRecord
  belongs_to :owner  # References User (owner_id)
# app/models/property.rb
has_many :bookings

  has_many_attached :images  # Active Storage for multiple images

  validates :name, presence: true
  validate :exactly_three_images

  # Optional: Display first image as thumbnail
  def primary_image
    images.first
  end

  private

  def exactly_three_images
    return unless images.attached?

    if images.count != 3
      errors.add(:images, "must have exactly 3 images")
    end
  end
end
