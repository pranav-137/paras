class CreateAccommodations < ActiveRecord::Migration[8.0]
  def change
    create_table :accommodations do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :street_address_2
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country
      t.string :email
      t.string :phone
      t.date :check_in
      t.date :check_out
      t.integer :adults
      t.integer :children

      t.timestamps
    end
  end
end
