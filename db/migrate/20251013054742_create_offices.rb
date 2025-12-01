class CreateOffices < ActiveRecord::Migration[8.0]
  def change
    create_table :offices do |t|
      t.integer :number
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
