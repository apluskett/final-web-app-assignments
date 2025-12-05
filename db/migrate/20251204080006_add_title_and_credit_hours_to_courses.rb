class AddTitleAndCreditHoursToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :title, :string
    add_column :courses, :credit_hours, :integer
  end
end