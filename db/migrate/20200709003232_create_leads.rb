class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :full_name
      t.string :picture_url
      t.string :linkedin_url
      t.string :status
      t.string :notes
      t.string :email
      t.string :phone_number
      t.integer :column_id

      t.timestamps
    end
  end
end
