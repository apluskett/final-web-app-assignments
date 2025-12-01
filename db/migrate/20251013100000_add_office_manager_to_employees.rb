class AddOfficeManagerToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_reference :employees, :office_manager, foreign_key: true, null: true
  end
end
