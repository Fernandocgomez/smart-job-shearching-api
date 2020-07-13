require "rails_helper"

RSpec.describe Board, type: :model do
  before(:each) do
    # This create an instance of the User model
    # create_test_instances.rb
    @user = defaul_user_instance
  end

  subject { described_class.new(name: "My amazing board", user_id: @user.id) }

  describe "Validations" do
    describe "name" do 
        it "must be presence" do 
            expect(subject).to be_valid
            subject.name = nil
            expect(subject).to_not be_valid
        end

        it "must be maxium 20 characters" do
            expect(subject).to be_valid
            subject.name = "ferba bdks dhd nd snd derder"
            expect(subject).to_not be_valid
        end

        it "must be minimun 2 characters" do 
            expect(subject).to be_valid
            subject.name = "a"
            expect(subject).to_not be_valid
        end

        it "must be only letters and white spaces" do 
            expect(subject).to be_valid
            subject.name = "this # % 323"
            expect(subject).to_not be_valid
        end
    end

    describe 'user_id' do
        it "must be presence" do 
            expect(subject).to be_valid
            subject.user_id = subject.user_id + 1
            expect(subject).to_not be_valid
        end
    end

  end
end
