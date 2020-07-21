class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name, default: "default", null: false
      t.string :last_name, default: "default", null: false
      t.string :city, default: "default", null: false
      t.string :state, default: "default", null: false
      t.string :zipcode, null: false

      t.timestamps
    end
  end
end
