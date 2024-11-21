require 'rails_helper'

RSpec.describe UnverifiedAccountDeleteJob, type: :job do
  let!(:unverified_old_users) { create_list(:user, 5, verified: false, created_at: 2.days.ago) }
  let!(:unverified_recent_users) { create_list(:user, 5, verified: false, created_at: 12.hours.ago) }
  let!(:verified_users) { create_list(:user, 5, created_at: 2.days.ago) }

  before do
    verified_users.each do |user|
      user.update(verified: true)
    end
  end

  it 'deletes only unverified users older than 24 hours' do
    expect { described_class.new.perform }
      .to change(User, :count).by(-unverified_old_users.size)
  end

  it 'does not delete recently created unverified users' do
    described_class.new.perform
    expect(User.where(user_id: unverified_recent_users.map(&:user_id)).count).to eq(unverified_recent_users.size)
  end

  it 'does not delete verified users' do
    described_class.new.perform
    expect(User.where(user_id: verified_users.map(&:user_id)).count).to eq(verified_users.size)
  end

  it 'processes users in batches' do
    expect(User).to receive_message_chain(:where, :where, :in_batches).with(of: 500)
    described_class.new.perform
  end
end
