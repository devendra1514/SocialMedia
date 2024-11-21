require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { build(:role, name: 'user') }

  describe 'Associations' do
    it { should have_many(:users).class_name(:User).with_foreign_key(:role_id).dependent(:destroy) }
  end

  describe 'Validations' do
    context 'name' do
      it 'is valid with valid role name' do
        expect(role).to be_valid
      end

      it 'is invalid with invalid role name' do
        role.name = 'invalid-name'
        expect(role).not_to be_valid
        expect(role.errors[:name]).to include(I18n.t('activerecord.errors.models.role.attributes.name.inclusion'))
      end

      it 'is invalid without name' do
        role.name = nil
        expect(role).not_to be_valid
        expect(role.errors[:name]).to include(I18n.t('activerecord.errors.models.role.attributes.name.blank'))
      end

      it 'is invalid with a duplicate role name' do
        role.save
        second_role = build(:role, name: 'user')
        expect(second_role).not_to be_valid
        expect(second_role.errors[:name]).to include(I18n.t('activerecord.errors.models.role.attributes.name.taken'))
      end
    end
  end
end
