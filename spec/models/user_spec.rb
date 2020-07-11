require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(
    username: "fernandocgomez",
    email: "fernandocgomez@live.com",
    password_digest: "password",
    first_name: "Fernando",
    last_name: "Gomez",
    street_address: "11900 City Park Central Ln",
    street_address_2: "7210",
    city: "Houston",
    state: "Tx",
    zipcode: 77047) }

  describe 'validations' do

    describe 'username' do
      it 'must be present' do
        expect(subject).to be_valid
        subject.username = nil
        expect(subject).to_not be_valid
      end
    end

  end
end
