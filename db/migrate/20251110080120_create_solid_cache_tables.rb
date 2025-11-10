class CreateSolidCacheTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_cache_entries do |t|
      t.binary :key, null: false
      t.binary :value, null: false
      t.datetime :created_at, null: false

      t.index [:key], unique: true
      t.index [:created_at]
    end
  end
end