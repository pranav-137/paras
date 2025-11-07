class RenameUserIdToTenantIdInBookings < ActiveRecord::Migration[7.0]
  def change
    rename_column :bookings, :user_id, :tenant_id
  end
end
