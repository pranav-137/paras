class Tenant < ApplicationRecord
    # validates :email,:phone,presence: true,uniqueness: true 
    has_many :tenantdocs, dependent: :destroy
validates :first_name, :last_name, :email, :city, :country, presence: true
end
