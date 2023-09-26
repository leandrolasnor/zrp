class CreateHeroes < ActiveRecord::Migration[7.0]
  def change
    create_table :heroes do |t|
      t.string :name, null: false
      t.integer :rank, null: false
      t.float :lat, default: 0.000
      t.float :lng, default: 0.000

      t.timestamps
    end
  end
end
