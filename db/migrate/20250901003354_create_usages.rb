class CreateUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :usages do |t|
      t.references :item, null: false, foreign_key: true
      t.date :used_on, null: false
      t.string :note

      t.timestamps
    end
  end
end
