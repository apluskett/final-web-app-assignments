class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.references :prefix, null: false, foreign_key: true
      t.string :number, null: false
      t.text :syllabus

      t.timestamps
    end

    add_index :courses, [:prefix_id, :number], unique: true
  end
end