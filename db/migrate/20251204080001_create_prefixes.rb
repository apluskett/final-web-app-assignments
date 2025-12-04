class CreatePrefixes < ActiveRecord::Migration[8.0]
  def change
    create_table :prefixes do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :prefixes, :name, unique: true
  end
end