class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :storage, default: false, null: false

      t.timestamps
    end
  end
end
