require "rails_helper"

RSpec.describe Column, type: :model do
  before(:each) do
    # This create an instance of the User model
    # create_test_instances.rb
    @user = defaul_user_instance
    @board = default_board(@user.id)
  end

  subject { described_class.new(name: "This is the first column", position: 0, board_id: @board.id) }

  describe "Validations" do
    describe "name" do
      it "must be prcense" do
        expect(subject).to be_valid
        subject.name = nil
        expect(subject).to_not be_valid
      end
      it "must be at least 5 characters long" do
        expect(subject).to be_valid
        subject.name = "This"
        expect(subject).to_not be_valid
      end
      it "must maximun 25 characters" do
        expect(subject).to be_valid
        subject.name = "This is the first column longger than 25 characters"
        expect(subject).to_not be_valid
      end
      it "must be only letters(lower case or uppercase) and white spaces" do
        expect(subject).to be_valid
        subject.name = "This is the first% 32"
        expect(subject).to_not be_valid
      end
    end
  end

  describe "position" do
    it "must be prcense" do
      expect(subject).to be_valid
      subject.position = nil
      expect(subject).to_not be_valid
    end
    it "must be an integer" do
      expect(subject).to be_valid
      subject.position = "f"
      expect(subject).to_not be_valid
    end
    it "must be a positive number" do
      expect(subject).to be_valid
      subject.position = -2
      expect(subject).to_not be_valid
    end
  end

  describe "board_id" do
    it "must be prcense" do
      expect(subject).to be_valid
      subject.board_id = nil
      expect(subject).to_not be_valid
    end
  end
end
