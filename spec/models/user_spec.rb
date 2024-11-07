require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    it { should belong_to(:role).class_name('Role').with_foreign_key(:role_id) }
    it { should have_many(:otps).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }

    it { should have_many(:liked_posts).through(:likes).source(:likeable) }
    it { should have_many(:liked_comments).through(:likes).source(:likeable) }
    it { should have_many(:liked_moments).through(:likes).source(:likeable) }

    it { should have_many(:follows_as_follower).class_name('Follow').with_foreign_key(:follower_id).dependent(:destroy) }
    it { should have_many(:followings).through(:follows_as_follower).source(:followed) }
    it { should have_many(:follows_as_followed).class_name('Follow').with_foreign_key(:followed_id).dependent(:destroy) }
    it { should have_many(:followers).through(:follows_as_followed).source(:follower) }

    it { should have_many(:created_groups).class_name('Group').with_foreign_key(:user_id).dependent(:destroy) }
    it { should have_many(:group_memberships).class_name('GroupMembership') }
    it { should have_many(:groups).through(:group_memberships).dependent(:destroy) }
    it { should have_many(:group_messages).class_name('GroupMessage').with_foreign_key(:sender_id).dependent(:destroy) }
    it { should have_many(:send_messages).class_name('DirectMessage').with_foreign_key(:sender_id).dependent(:destroy) }
    it { should have_many(:recieved_messages).class_name('DirectMessage').with_foreign_key(:recipient_id).dependent(:destroy) }
    it { should have_many(:moments).class_name('Moment').with_foreign_key(:user_id).dependent(:destroy) }
    it { should have_many(:views).class_name('View').dependent(:destroy) }
  end

  describe 'validations' do
    before { create(:user, full_phone_number: '+919898989898') }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:full_phone_number).case_insensitive }
    it { should validate_uniqueness_of(:username).case_insensitive }

    it 'is invalid with an avatar larger than 10 MB' do
      user.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/files/20mb.png')), filename: '20mb.png', content_type: 'image/png')
      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include("File size should be less than 10 MB.")
    end

    it 'is valid with an avatar smaller than 10 MB' do
      user.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/files/100kb.png')), filename: '100kb.png', content_type: 'image/png')
      expect(user).to be_valid
    end

    it 'is invalid with an unsupported content type' do
      user.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/files/1mb.mp4')), filename: '1mb.mp4', content_type: 'text/plain')
      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include("Invalid file type. Please upload a image file.")
    end

    it 'is valid with a supported content type' do
      user.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/files/100kb.png')), filename: '100kb.png', content_type: 'image/png')
      expect(user).to be_valid
    end
  end

  describe 'callbacks' do
    context 'before validation' do
      it 'formats phone number to E.164 format' do
        user.full_phone_number = '919999999999'
        user.save
        expect(user.full_phone_number).to eq('+919999999999')
      end

      it 'does not change the phone number if it is already in E.164 format' do
        user.full_phone_number = '+919999999999'
        user.save
        expect(user.full_phone_number).to eq('+919999999999')
      end
    end

    context 'before create' do
      it 'sets verified to false' do
        expect(user.verified).to eq(true)
        user.save
        expect(user.verified).to eq(false)
      end
    end

    context 'after create commit' do
      it 'sends an OTP' do
        expect { user.save }.to change { Otp.count }.by(1)
        expect(user.otps.last.purpose).to eq('login')
      end

      it 'processes the avatar thumbnail' do
        user.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/files/100kb.png')), filename: '100kb.png', content_type: 'image/png')
        user.save
        expect(user.reload.avatar.variant(resize_to_fill: SMALL_THUMB_SIZE).present?).to eq(true)
      end
    end
  end
end
