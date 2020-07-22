module InstanceHelper
  @@user_params = {
    "username" => "fernandocgomez",
    "email" => "fernandocgomez@live.com",
    "password_digest" => "Ilovemytacos32%",
    "password_digest_confirmation" => "Ilovemytacos32%",
    "first_name" => "Fernando",
    "last_name" => "Gomez",
    "city" => "Houston",
    "state" => "Tx",
    "zipcode" => "77047",
  }

  @@user_invalid_params = {
    "username" => nil,
    "email" => "fernandocgomez@live.com",
    "password_digest" => "Ilovemytacos32%",
    "password_digest_confirmation" => "Ilovemytacos32%",
    "first_name" => "Fernando",
    "last_name" => "Gomez",
    "city" => "Houston",
    "state" => "Tx",
    "zipcode" => "77047",
  }

  @@user_matcher = {
    "username" => "fernandocgomez",
    "email" => "fernandocgomez@live.com",
    "first_name" => "Fernando",
    "last_name" => "Gomez",
    "city" => "Houston",
    "state" => "Tx",
    "zipcode" => "77047",
  }

  @@lead_params = {
    "first_name" => "Andrew",
    "last_name" => "Sprague", 
    "picture_url" => "https://media-exp1.licdn.com/dms/image/C5603AQE56P4YUjdGiw/profile-displayphoto-shrink_100_100/0?e=1599696000&v=beta&t=ZI3-yK0vAH9NH-XSH5Xq70G0nKsdBUHhAjeYEqd1w8s", 
    "linkedin_url" => "/in/andrew-sprague-cfa/", 
    "status" => "new", 
    "notes" => "write a note...", 
    "email" => "asprague@outlook.com",
    "phone_number" => "3462600832", 
    "column_id" => nil,
    "company_id" => nil
  }

  # <----------- User --------------->

  def create_user
    User.create(@@user_params)
  end

  def create_user_instance
    User.new(@@user_params)
  end

  def create_user_without_validations
    User.create!(@@user_params)
  end

  def get_user_params
    @@user_params
  end

  def get_user_matcher
    @@user_matcher
  end

  def get_user_invalid_params
    @@user_invalid_params
  end

  # <----------- Board --------------->

  def get_board_params(user_id)
    {
      "name" => "My new board",
      "user_id" => user_id,
    }
  end

  def get_board_invalid_params
    {
      "name" => "My new board",
      "user_id" => nil,
    }
  end

  def create_board(user_id)
    Board.create({
      "name" => "My new board",
      "user_id" => user_id,
    })
  end

  # <----------- Column --------------->

  def get_column_params(board_id)
    {
      "name" => "My first column",
      "position" => 0,
      "board_id" => board_id,
    }
  end

  def get_invalid_column_params(board_id)
    {
      "name" => nil,
      "position" => 0,
      "board_id" => board_id,
    }
  end

  def create_column(board_id)
    Column.create({
      "name" => "My first column",
      "position" => 0,
      "board_id" => board_id,
    })
  end

  # <----------- Company ---------------->

  def create_company
    Company.create({
      "name" => "Just Energy",
      "linkedin_url" => "/company/just-energy_2/life/",
    })
  end

  # <----------- Lead ---------------->
  def create_lead_instance(column_id, company_id)
    lead_params_copy = @@lead_params.clone
    lead_params_copy['column_id'] = column_id
    lead_params_copy['company_id'] = company_id
    Lead.create(lead_params_copy)
  end

  def get_lead_params_copy
    lead_params_copy = @@lead_params.clone
  end


end
