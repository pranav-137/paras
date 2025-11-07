class Tenantdoc < ApplicationRecord
  belongs_to :tenant
  has_one_attached :profile_pic
  has_one_attached :document
  validates :doc_type, presence: true
end