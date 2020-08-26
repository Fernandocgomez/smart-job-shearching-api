require "rails_helper"

RSpec.describe Column, type: :model do
  
  let(:user) { create(:user) }
  let(:board) { create(:board, user_id: user.id) }
  subject { build(:column, board_id: board.id) }

  describe "Validations" do
    
    context "when a column instance is initialized" do
      it "passes all the validations" do
        expect(subject).to be_valid
      end
    end

    describe "name" do
      it "must be prcense" do
        subject.name = nil

        expect(subject).to_not be_valid
      end
      it "must be at least 5 characters long" do
        subject.name = "This"

        expect(subject).to_not be_valid
      end
      it "must maximun 25 characters" do
        subject.name = "This is the first column longger than 25 characters"

        expect(subject).to_not be_valid
      end
      it "must be only letters(lower case or uppercase) and white spaces" do
        subject.name = "This is the first% 32"
        
        expect(subject).to_not be_valid
      end
    end
  end

  describe "position" do
    it "must be prcense" do
      subject.position = nil

      expect(subject).to_not be_valid
    end
    it "must be an integer" do
      subject.position = "f"

      expect(subject).to_not be_valid
    end
    it "must be a positive number" do
      subject.position = -2

      expect(subject).to_not be_valid
    end
  end

  describe "board_id" do
    it "must be prcense" do
      subject.board_id = nil

      expect(subject).to_not be_valid
    end

    it "must exist on the DB" do
      subject.board_id = subject.board_id + 1

      expect(subject).to_not be_valid
    end
  end

end
