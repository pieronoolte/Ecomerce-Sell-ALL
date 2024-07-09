require "test_helper"

class Authentication::SessionsControllerTest < ActionDispatch::IntegrationTest

    def setup 
        @user=users(:paco)
    end
 
    test "should get new" do
        get new_session_url
        assert_response :success
    end

    test "should login an user by email" do
        
        post sessions_url, params: { login: @user.email, password: '1234test' }
        assert_redirected_to products_path
    end

    test "should login an user by username" do
        
        post sessions_url, params: { login: @user.username, password: '1234test' }
        assert_redirected_to products_path
    end

    test "should logout" do       
        login
        delete session_url(@user.id)
        assert_redirected_to products_path
    end

end
