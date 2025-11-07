class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.text :description
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
