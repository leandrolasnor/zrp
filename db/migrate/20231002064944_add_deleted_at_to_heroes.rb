class AddDeletedAtToHeroes < ActiveRecord::Migration[7.0]
  def change
    add_column :heroes, :deleted_at, :datetime
    add_index :heroes, :deleted_at
  end
end
