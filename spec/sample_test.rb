require 'rails_helper'

describe 'GetTime' do
  let(:current_time) { Time.current }

  before(:each) do
    puts("Before Each")
    sleep(1)
    puts(Time.current)
    sleep(1)
    puts(current_time)
    puts("Before Each End")
  end

  it "gets the same time over and over again" do
    puts("gets the same time over and over again")
    puts current_time
    sleep(2)
    puts current_time
  end

  it "gets the time again" do
    puts 'gets the time again'
    puts current_time
  end
end
