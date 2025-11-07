class Ownerdoc < ApplicationRecord
  belongs_to :owner
  has_one_attached :profile_pic   
  has_one_attached :document
end
