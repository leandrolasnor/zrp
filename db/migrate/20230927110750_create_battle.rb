class CreateBattle < ActiveRecord::Migration[7.0]
  def change
    create_table :battles do |t|
      t.integer :score
      t.integer :hero_id, null: false
      t.integer :threat_id, null: false
      t.datetime :finished_at, null: false

      t.timestamps
    end
    add_foreign_key :battles, :heroes, column: :hero_id
    add_foreign_key :battles, :threats, column: :threat_id
    add_index :battles, :score
  end
end
