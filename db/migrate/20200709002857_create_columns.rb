class CreateColumns < ActiveRecord::Migration[6.0]
  def change
    create_table :columns do |t|
      t.string :name, null: false
      t.integer :position, null: false
      t.integer :board_id, null: false

      t.timestamps
    end
  end
end
