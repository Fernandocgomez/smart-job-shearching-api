class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :linkedin_url, null: false
      t.string :website, default: "wwww.companyxwy.com", null: true
      t.text :about, default: "about the company", null: true


      t.timestamps
    end
  end
end
