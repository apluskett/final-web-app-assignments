class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :name, null: false
      t.string :student_id, null: false

      t.timestamps
    end

    add_index :students, :student_id, unique: true
  end
end