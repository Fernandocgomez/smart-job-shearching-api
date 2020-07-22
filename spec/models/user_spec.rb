require "rails_helper"

RSpec.describe User, type: :model do
  subject {
    # This create an instance of the User model
    # requests_helper.rb
    create_user_instance
  }

  describe "validations" do
    describe "username" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.username = nil
        expect(subject).to_not be_valid
      end

      it "must be unique" do
        # This create an instance of the User model without validations (create!)
        # requests_helper.rb
        create_user_without_validations

        expect(subject).to_not be_valid
      end

      it "must be at least 8 characters" do
        expect(subject).to be_valid
        subject.username = "fer"
        expect(subject).to_not be_valid
      end

      it 'must be a maximum of 20 characters' do
        expect(subject).to be_valid
        subject.username = "fernandomasonetwothreefourfivesix"
        expect(subject).to_not be_valid
      end

      it 'must be only upper and lower cases' do
        expect(subject).to be_valid
        subject.username = "fernandoc gomez"
        expect(subject).to_not be_valid
      end
    end

    describe "email" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.email = nil
        expect(subject).to_not be_valid
      end

      it "must be unique" do
        # This create an instance of the User model without validations (create!)
        # requests_helper.rb
        create_user_without_validations

        expect(subject).to_not be_valid
      end

      it "must be a valid email" do
        expect(subject).to be_valid
        subject.email = "invalidemail@invalidemailcom"
        expect(subject).to_not be_valid
      end
    end

    describe "password_digest" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.password_digest = nil
        expect(subject).to_not be_valid
      end

      it "must be at least 8 characters" do
        expect(subject).to be_valid
        subject.password_digest = "Ilovfe"
        expect(subject).to_not be_valid
      end
      it "must be a maximum of 25 characters" do
        expect(subject).to be_valid
        subject.password_digest = "Ilovemytacos32%ferferferferferferferferferfer"
        expect(subject).to_not be_valid
      end

      it "must contain at least one special character" do
        expect(subject).to be_valid
        subject.password_digest = "Ilovemytacos32"
        expect(subject).to_not be_valid
      end

      it "must contain at least one lowercase letter" do
        expect(subject).to be_valid
        subject.password_digest = "ILOVEMYTACOS32%"
        expect(subject).to_not be_valid
      end

      it "must contain at least one uppercase letter" do
        expect(subject).to be_valid
        subject.password_digest = "ilovemytacos32%"
        expect(subject).to_not be_valid
      end

      it "must contain at least one digit" do
        expect(subject).to be_valid
        subject.password_digest = "Ilovemytacos%"
        expect(subject).to_not be_valid
      end
    end

    describe "password_digest_confirmation" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.password_digest_confirmation = nil
        expect(subject).to_not be_valid
      end

      it "must match with password_digest" do
        expect(subject).to be_valid
        subject.password_digest_confirmation = "Differentpassword%"
        expect(subject).to_not be_valid
      end
    end

    describe "first_name" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.first_name = nil
        expect(subject).to_not be_valid
      end

      it 'must have a default value' do
        params = get_user_params.clone
        params.except!("first_name")
        user = User.create(params)
        expect(user).to be_valid
        expect(user['first_name']).to eql("default")
      end

      it "must be only upper and lower cases" do
        expect(subject).to be_valid
        subject.first_name = "Fernando32%"
        expect(subject).to_not be_valid
      end

      it "must be at least 2 characters and not larger than 15" do
        expect(subject).to be_valid
        subject.first_name = "Fernandoferferferferferferferfer"
        expect(subject).to_not be_valid
        subject.first_name = "F"
        expect(subject).to_not be_valid
      end
    end

    describe "last_name" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.last_name = nil
        expect(subject).to_not be_valid
      end

      it 'must have a default value' do
        params = get_user_params.clone
        params.except!("last_name")
        user = User.create(params)
        expect(user).to be_valid
        expect(user['last_name']).to eql("default")
      end

      it "must be only upper and lower cases" do
        expect(subject).to be_valid
        subject.last_name = "Gomez32%"
        expect(subject).to_not be_valid
      end

      it "must be at least 2 characters and not larger than 15" do
        expect(subject).to be_valid
        subject.last_name = "Gomezferferferferferferferfer"
        expect(subject).to_not be_valid
        subject.last_name = "G"
        expect(subject).to_not be_valid
      end
    end

    describe "city" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.city = nil
        expect(subject).to_not be_valid
      end
      it 'must have a default value' do
        params = get_user_params.clone
        params.except!("city")
        user = User.create(params)
        expect(user).to be_valid
        expect(user['city']).to eql("default")
      end
    end

    describe "state" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.state = nil
        expect(subject).to_not be_valid
      end
      it 'must have a default value' do
        params = get_user_params.clone
        params.except!("state")
        user = User.create(params)
        expect(user).to be_valid
        expect(user['state']).to eql("default")
      end
    end

    describe "zipcode" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.zipcode = nil
        expect(subject).to_not be_valid
      end

      it "must be five digits" do
        expect(subject).to be_valid
        subject.zipcode = "7704"
        expect(subject).to_not be_valid
      end

      it 'must be only numbers' do
        expect(subject).to be_valid
        subject.zipcode = "7704f"
        expect(subject).to_not be_valid
      end

      it 'must be a valid USA zipcode' do
        # we need to research libraries that can help us to acomplish this validation 
        # https://github.com/dgilperez/validates_zipcode
      end

    end
  end
end
