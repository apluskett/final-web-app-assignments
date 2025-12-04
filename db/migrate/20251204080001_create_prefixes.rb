class CreatePrefixes < ActiveRecord::Migration[8.0]
  def change
    create_table :prefixes do |t|
      t.string :code, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :prefixes, :code, unique: true
  end
end