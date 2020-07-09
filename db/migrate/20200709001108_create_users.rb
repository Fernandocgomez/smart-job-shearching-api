class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :street_address_2
      t.string :city
      t.string :state
      t.integer :zipcode

      t.timestamps
    end
  end
end
