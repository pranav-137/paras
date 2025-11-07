class CreateTenantdocs < ActiveRecord::Migration[8.0]
  def change
    create_table :tenantdocs do |t|
      t.string :name
      t.string :doc_type
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
