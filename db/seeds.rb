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
JobPosition.destroy_all
LeadEmail.destroy_all
Company.destroy_all



user_1 = User.create(
    username: "fernandocgomez", 
    email: "fernandocgomez@live.com", 
    password_digest: "Ilovemytacos32%",
    password_digest_confirmation: "Ilovemytacos32%",
    first_name: "Fernando", 
    last_name: "Gomez", 
    street_address: "11900 City Park Central Ln", 
    street_address_2: "7210", 
    city: "Houston", 
    state: "Tx", 
    zipcode: "77047"
)

company_1 = Company.create(
    name: "Just Energy", 
    linkedin_url: "/company/just-energy_2/life/"
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
    first_name: "Andrew",
    last_name: "Sprague", 
    picture_url: "https://media-exp1.licdn.com/dms/image/C5603AQE56P4YUjdGiw/profile-displayphoto-shrink_100_100/0?e=1599696000&v=beta&t=ZI3-yK0vAH9NH-XSH5Xq70G0nKsdBUHhAjeYEqd1w8s", 
    linkedin_url: "/in/andrew-sprague-cfa/", 
    status: "new", 
    notes: "write a note...", 
    email: "asprague@outlook.com",
    phone_number: "346-260-0832", 
    column_id: column_1.id,
    company_id: company_1.id
)

job_position_1 = JobPosition.create(
    name: "Front End Developer", 
    city: "Houston", 
    state: "TX", 
    applied: false, 
    user_id: user_1.id, 
    company_id: company_1.id
)

lead_email_1 = LeadEmail.create(
    email: "example@example.com", 
    subject: "software Engineer Position",
    email_body: "Hello #{lead_1.first_name}, I am contacting you regarding to the #{job_position_1.name}", 
    sent: false, 
    open: false,
    lead_id: lead_1.id, 
    job_position_id: job_position_1.id
)
