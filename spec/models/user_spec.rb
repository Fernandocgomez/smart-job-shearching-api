require "rails_helper"

RSpec.describe User, type: :model do
  subject {
    described_class.new(
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
      zipcode: "77047",
    )
  }

  describe "validations" do
    describe "username" do
      it "must be present" do
        expect(subject).to be_valid
        subject.username = nil
        expect(subject).to_not be_valid
      end

      it "must be unique" do
        described_class.create!(
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
          zipcode: 77047,
        )

        expect(subject).to_not be_valid
      end

      it "must be 8 to 20 characters" do
        expect(subject).to be_valid
        subject.username = "fer"
        expect(subject).to_not be_valid
      end
    end

    describe "email" do
      it "must be present" do
        expect(subject).to be_valid
        subject.email = nil
        expect(subject).to_not be_valid
      end

      it "must be unique" do
        described_class.create!(
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
          zipcode: 77047,
        )

        expect(subject).to_not be_valid
      end

      it "must be a valid email format" do
        expect(subject).to be_valid
        subject.email = "invalidemail@invalidemailcom"
        expect(subject).to_not be_valid
      end
    end

    describe "password_digest" do
      it "must be present" do
        expect(subject).to be_valid
        subject.password_digest = nil
        expect(subject).to_not be_valid
      end

      it "must be 8 to 40 characters" do
        expect(subject).to be_valid
        subject.password_digest = "Ilov32%"
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
      it "must be present" do
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

    describe 'first_name' do
      it "must be presence"  do 
        expect(subject).to be_valid
        subject.first_name = nil
        expect(subject).to_not be_valid
      end

      it "only letters are allowed" do 
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

    describe 'last_name' do
      it "must be presence"  do 
        expect(subject).to be_valid
        subject.last_name = nil
        expect(subject).to_not be_valid
      end

      it "only letters are allowed" do 
        expect(subject).to be_valid
        subject.last_name = "Gomez32%"
        expect(subject).to_not be_valid
      end

      it "must be at least 2 characters and not larger than 15" do 
        expect(subject).to be_valid
        subject.last_name = "Gomezferferferferferferferferferfer"
        expect(subject).to_not be_valid
        subject.last_name = "G"
        expect(subject).to_not be_valid
      end 
    end

    describe 'street_address' do
      it "must be presence" do 
        expect(subject).to be_valid
        subject.street_address = nil
        expect(subject).to_not be_valid
      end
    end

    describe 'street_address_2' do
      it "must be presence" do 
        expect(subject).to be_valid
        subject.street_address_2 = nil
        expect(subject).to_not be_valid
      end
    end

    describe 'city' do
      it "must be presence" do 
        expect(subject).to be_valid
        subject.city = nil
        expect(subject).to_not be_valid
      end
    end

    describe 'state' do
      it "must be presence" do 
        expect(subject).to be_valid
        subject.state = nil
        expect(subject).to_not be_valid
      end
    end

    describe 'zipcode' do

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

    end

  end
end
