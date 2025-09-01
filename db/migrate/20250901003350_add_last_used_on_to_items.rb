class AddLastUsedOnToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :last_used_on, :date
  end
end
