class AddStatusToOwnerdocs < ActiveRecord::Migration[8.0]
  def change
    add_column :ownerdocs, :status, :string
  end
end
