class CreateLeadEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :lead_emails do |t|
      t.string :email, default: "example@example.com", null: false
      t.string :subject, default: "write an eye catching email subject", null: false
      t.string :email_body, default: "compost an email...", null: false
      t.boolean :sent, default: false, null: false
      t.boolean :open, default: false, null: false
      t.integer :lead_id, null: false
      t.integer :job_position_id, null: false

      t.timestamps
    end
  end
end
