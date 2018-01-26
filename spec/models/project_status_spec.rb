require 'rails_helper'

RSpec.describe ProjectStatus, type: :model do
  before { ActsAsTenant.current_tenant = FactoryBot.create :user }
  after { ActsAsTenant.current_tenant = nil }

  it 'has a valid factory' do
    expect(FactoryBot.create(:project_status)).to be_valid
  end

  it 'is invalid without a unique name' do
    FactoryBot.create(:project_status, name: 'I am a post')

    expect(FactoryBot.build(:project_status, name: 'I am a post')).not_to be_valid
  end

  it 'is invalid without a unique slug' do
    FactoryBot.create(:project_status, slug: 'test-status')

    expect(FactoryBot.build(:project_status, slug: 'test-status')).not_to be_valid
  end
end
