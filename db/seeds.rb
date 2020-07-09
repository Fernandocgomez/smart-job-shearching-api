# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Board.destroy_all
Column.destroy_all
Lead.destroy_all

user_1 = User.create(
    username: "fernandocgomez", 
    email: "fernandocgomez@live.com", 
    password_digest: "password", 
    first_name: "Fernando", 
    last_name: "Gomez", 
    street_address: "11900 City Park Central Ln", 
    street_address_2: "7210", 
    city: "Houston", 
    state: "Tx", 
    zipcode: 77047
)

board_1 = Board.create(
    name: "My first board", 
    user_id: user_1.id
)

column_1 = Column.create(
    name: "New Lead", 
    position: 0, 
    board_id: board_1.id
)

lead_1 = Lead.create(
    full_name: "Andrew Sprague", 
    picture_url: "https://media-exp1.licdn.com/dms/image/C5603AQE56P4YUjdGiw/profile-displayphoto-shrink_100_100/0?e=1599696000&v=beta&t=ZI3-yK0vAH9NH-XSH5Xq70G0nKsdBUHhAjeYEqd1w8s", 
    linkedin_url: "/in/andrew-sprague-cfa/", 
    status: "New", 
    notes: "write note...", 
    email: "ndrewsprague@outlook.com", 
    phone_number: "", 
    column_id: column_1.id
)

user_2 = User.create(
    username: "cristobal", 
    email: "cristobal@live.com", 
    password_digest: "password", 
    first_name: "Cristobal", 
    last_name: "Gomez", 
    street_address: "11900 City Park Central Ln", 
    street_address_2: "7211", 
    city: "Houston", 
    state: "Tx", 
    zipcode: 77047
)

board_2 = Board.create(
    name: "My first board", 
    user_id: user_2.id
)

column_2 = Column.create(
    name: "New Lead", 
    position: 0, 
    board_id: board_2.id
)

lead_2 = Lead.create(
    full_name: "Andrew Sprague", 
    picture_url: "https://media-exp1.licdn.com/dms/image/C5603AQE56P4YUjdGiw/profile-displayphoto-shrink_100_100/0?e=1599696000&v=beta&t=ZI3-yK0vAH9NH-XSH5Xq70G0nKsdBUHhAjeYEqd1w8s", 
    linkedin_url: "/in/andrew-sprague-cfa/", 
    status: "New", 
    notes: "write note...", 
    email: "ndrewsprague@outlook.com", 
    phone_number: "", 
    column_id: column_2.id
)