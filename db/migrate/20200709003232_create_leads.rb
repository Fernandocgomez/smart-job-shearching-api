class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :picture_url, default: "https://mail.achieverspoint.com/img/default-avatar.jpg", null: false
      t.string :linkedin_url, null: false
      t.string :status, default: "new", null: false
      t.string :notes, default: "write a note...", null: false 
      t.string :email, null: true
      t.string :phone_number, default: "add phone number", null: false
      t.integer :column_id, null: false
      t.integer :company_id, null: false

      t.timestamps
    end
  end
end
