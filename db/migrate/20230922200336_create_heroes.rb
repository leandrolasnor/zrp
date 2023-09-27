class CreateHeroes < ActiveRecord::Migration[7.0]
  def change
    create_table :heroes do |t|
      t.string :name, null: false
      t.integer :rank, null: false
      t.integer :status, default: 1, null: false
      t.decimal :lat, precision: 18, scale: 15, null: true
      t.decimal :lng, precision: 18, scale: 15, null: true

      t.timestamps
    end
  end
end
