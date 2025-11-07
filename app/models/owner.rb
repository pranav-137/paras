class Owner < ApplicationRecord
  belongs_to :user
has_many :ownerdocs, dependent: :destroy
  has_many :properties,dependent: :destroy
end
