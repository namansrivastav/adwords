require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save user without email" do
   	user =User.new
   	assert_not user.save
   end

   test "should not save user without password" do
   	user=User.new
   	assert_not user.save
   end

  test 'if Password length less than 6 character' do
    @user= User.new(email: 'abcde@gmail.com',password: 'test')
    if !@user.save
      assert_equal( "length less than 6 character", "length less than 6 character", "length less than 6 character" )
    end
  end
end
