class CreateOwnerdocs < ActiveRecord::Migration[8.0]
  def change
    create_table :ownerdocs do |t|
      t.string :name
      t.string :doc_type
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
