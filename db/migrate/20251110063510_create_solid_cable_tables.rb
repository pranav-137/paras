class CreateSolidCableTables < ActiveRecord::Migration[8.0]
  def change
    create_table :cable_messages do |t|
      t.string   :channel
      t.text     :payload
      t.datetime :created_at, null: false
      t.datetime :expires_at

      t.index [:channel]
      t.index [:expires_at]
    end
  end
end