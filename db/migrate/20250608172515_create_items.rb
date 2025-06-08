class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.references :location, null: true, foreign_key: true
      t.string :name, null: false
      t.text :note
      t.monetize :purchase_value, null: false
      t.monetize :current_value, null: false
      t.date :acquired_on
      t.date :discarded_on
      t.date :last_seen_on
      t.integer :expected_uses, default: 30, null: false

      t.timestamps
    end
  end
end
