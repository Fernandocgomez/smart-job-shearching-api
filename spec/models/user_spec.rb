require "rails_helper"

RSpec.describe User, type: :model do
  subject { init_user_instance }

  describe "validations" do

    context 'when user instance is initialized' do
      it 'passes all the validations' do
        expect(subject).to be_valid
      end
    end
    
    describe "username" do
      it "must be presence" do
        subject.username = nil

        expect(subject).to_not be_valid
      end

      it "must be unique" do
        create(:user)

        expect(subject).to_not be_valid
      end

      it "must be at least 8 characters" do
        subject.username = "fer"

        expect(subject).to_not be_valid
      end

      it "must be a maximum of 20 characters" do
        subject.username = "fernandomasonetwothreefourfivesix"

        expect(subject).to_not be_valid
      end

      it "must be only upper and lower cases" do
        subject.username = "fernandoc gomez"

        expect(subject).to_not be_valid
      end
    end

    describe "email" do
      it "must be presence" do
        subject.email = nil

        expect(subject).to_not be_valid
      end

      it "must be unique" do
        create(:user)

        expect(subject).to_not be_valid
      end

      it "must be a valid email" do
        subject.email = "invalidemail@invalidemailcom"

        expect(subject).to_not be_valid
      end
    end

    describe "password" do
      it "must be presence" do
        subject.password = nil

        expect(subject).to_not be_valid
      end

      it "must be at least 8 characters" do
        subject.password = "Ilovfe"

        expect(subject).to_not be_valid
      end
      it "must be a maximum of 25 characters" do
        subject.password = "Ilovemytacos32%ferferferferferferferferferfer"

        expect(subject).to_not be_valid
      end

      it "must contain at least one special character" do
        subject.password = "Ilovemytacos32"

        expect(subject).to_not be_valid
      end

      it "must contain at least one lowercase letter" do
        subject.password = "ILOVEMYTACOS32%"

        expect(subject).to_not be_valid
      end

      it "must contain at least one uppercase letter" do
        subject.password = "ilovemytacos32%"

        expect(subject).to_not be_valid
      end

      it "must contain at least one digit" do
        subject.password = "Ilovemytacos%"

        expect(subject).to_not be_valid
      end
    end

    describe "password_confirmation" do
      it "must be presence" do
        subject.password_confirmation = nil

        expect(subject).to_not be_valid
      end

      it "must match with password" do
        subject.password_confirmation = "Differentpassword%"

        expect(subject).to_not be_valid
      end
    end

    describe "first_name" do
      it "must be presence" do
        subject.first_name = nil

        expect(subject).to_not be_valid
      end

      it "must have a default value" do
        user = init_instance_with_default_value(User, ParamsHelper.get_user_params, "first_name")

        expect(user).to be_valid
        expect(user["first_name"]).to eql("default")
      end

      it "must be only upper and lower cases" do
        subject.first_name = "Fernando32%"

        expect(subject).to_not be_valid
      end

      it "must be minimun 2 characters" do
        subject.first_name = "F"

        expect(subject).to_not be_valid
      end

      it "must be minimun 15 characters" do
        subject.first_name = "Fernandoferferferferferferferfer"

        expect(subject).to_not be_valid
      end
    end

    describe "last_name" do
      it "must be presence" do
        subject.last_name = nil

        expect(subject).to_not be_valid
      end

      it "must have a default value" do
        user = init_instance_with_default_value(User, ParamsHelper.get_user_params, "last_name")

        expect(user).to be_valid
        expect(user["last_name"]).to eql("default")
      end

      it "must be only upper and lower cases" do
        subject.last_name = "Gomez32%"

        expect(subject).to_not be_valid
      end

      it "must be minimun 2 characters" do
        subject.last_name = "G"

        expect(subject).to_not be_valid
      end

      it "must be minimun 15 characters" do
        subject.last_name = "Gomezferferferferferferferfer"

        expect(subject).to_not be_valid
      end
    end

    describe "city" do
      it "must be presence" do
        subject.city = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        user = init_instance_with_default_value(User, ParamsHelper.get_user_params, "city")

        expect(user).to be_valid
        expect(user["city"]).to eql("default")
      end
    end

    describe "state" do
      it "must be presence" do
        subject.state = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        user = init_instance_with_default_value(User, ParamsHelper.get_user_params, "state")

        expect(user).to be_valid
        expect(user["state"]).to eql("default")
      end
    end

    describe "zipcode" do
      it "must be presence" do
        subject.zipcode = nil

        expect(subject).to_not be_valid
      end

      it "must be five digits" do
        subject.zipcode = "7704"

        expect(subject).to_not be_valid
      end

      it "must be only numbers" do
        subject.zipcode = "7704f"

        expect(subject).to_not be_valid
      end

      it "must be a valid USA zipcode" do
        # we need to research libraries that can help us to acomplish this validation
        # https://github.com/dgilperez/validates_zipcode
      end
    end
  end
end
