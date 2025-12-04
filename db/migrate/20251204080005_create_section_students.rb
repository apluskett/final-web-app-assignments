class CreateSectionStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :section_students do |t|
      t.references :section, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end

    add_index :section_students, [:section_id, :student_id], unique: true
  end
end