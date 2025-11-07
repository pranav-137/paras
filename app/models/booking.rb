# class Booking < ApplicationRecord
#   belongs_to :user
#   belongs_to :property
#   belongs_to :tenant, class_name: "User", foreign_key: "tenant_id"
#   validates :start_date, presence: true
# end
class Booking < ApplicationRecord
  belongs_to :property
  belongs_to :tenant, class_name: "User", foreign_key: "tenant_id"  # tenant user who booked

  validates :start_date, presence: true
end
