class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :name
      t.float :price
      t.string :availability

      t.timestamps
    end
  end
end
