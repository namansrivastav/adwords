require 'test_helper'
include Warden::Test::Helpers

class HomesControllerTest < ActionController::TestCase

	before do
  
    @user = User.create(:email => "test@gmail.com", :password => "12345678", :password_confirmation => "12345678")
    sign_in @user
    @home = homes(:one)
    
	end

  	test "the truth" do
    	assert true
  	end

  	it "should get index" do
        get :index    
        assert_response :success
    end

    it "should get new" do
    	get :new
    	assert_response :success
  	end

    it "should create file" do
      test_file =  "test/fixtures/files/details.csv"
  		file = Rack::Test::UploadedFile.new(test_file, "text/csv")
      assert_difference 'Home.count',1 do
  		  post :create, :home =>{data: file} 
  		  assert_response :redirect
      end
    end

    it "should show file" do
	    get :show, id: homes(:one)
	    assert_response :success
  	end

  	it "should destroy file" do
	    assert_difference 'Home.count',-1 do 
	      delete :destroy, :id => @home.to_param
	      assert_response :redirect
	    end
  	end

end
