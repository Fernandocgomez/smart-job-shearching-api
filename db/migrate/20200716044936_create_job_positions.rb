class CreateJobPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :job_positions do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.boolean :applied, default: false, null: false
      t.integer :user_id, null: false
      t.integer :company_id, null: false

      t.timestamps
    end
  end
end
