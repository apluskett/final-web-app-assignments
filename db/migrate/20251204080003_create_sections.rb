class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.references :course, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end

    add_index :sections, [:course_id, :name], unique: true
  end
end