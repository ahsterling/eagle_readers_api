require 'rails_helper'

RSpec.describe Book, :type => :model do

  describe '.validations' do
    it 'is invalid without a title' do
      expect(Book.new(title: nil)).to be_invalid
    end
  end

end
