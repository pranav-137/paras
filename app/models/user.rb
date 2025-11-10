class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Associations
  has_one :owner, dependent: :destroy   # Connect User to Owner profile
  has_many :properties, foreign_key: :owner_id, dependent: :destroy
  has_many :tenantdocs, foreign_key: :tenant_id, dependent: :destroy
  has_many :bookings_as_tenant, class_name: 'Booking', foreign_key: :tenant_id, dependent: :destroy
  has_many :bookings_as_owner, through: :properties, source: :bookings

  # THIS IS THE MISSING LINE
  has_many :ownerdocs, through: :owner  # So User can access ownerdocs via Owner

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[admin owner tenant] }

  # Role helpers
  def admin?
    role == 'admin'
  end

  def owner?
    role == 'owner'
  end

  def tenant?
    role == 'tenant'
  end
end
