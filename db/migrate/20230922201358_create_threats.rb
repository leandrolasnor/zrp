class CreateThreats < ActiveRecord::Migration[7.0]
  def change
    create_table :threats do |t|
      t.string :name, null: true
      t.integer :rank, null: true
      t.integer :status, default: 1
      t.decimal :lat, precision: 18, scale: 15, null: true
      t.decimal :lng, precision: 18, scale: 15, null: true
      t.text :payload, null: false

      t.timestamps
    end
  end
end
