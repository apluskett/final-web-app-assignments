class CreateOfficeManagers < ActiveRecord::Migration[8.0]
  def change
    create_table :office_managers do |t|
      t.string :name

      t.timestamps
    end
  end
end
