class CreateOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :owners do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address_line
      t.string :city
      t.string :state
      t.string :country
      t.integer :pin_code

      t.timestamps
    end
  end
end
