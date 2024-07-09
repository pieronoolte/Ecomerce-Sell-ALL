require "test_helper"

class Authentication::UsersControllerTest < ActionDispatch::IntegrationTest
 
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    stub_request(:get, "http://ip-api.com/json/request.remote_ip").
    with(
      headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'ip-api.com',
            'User-Agent'=>'Ruby'
      }).
      to_return(status: 200, body: {
        status: "fail"
      }.to_json, headers: {})
    assert_difference("User.count") do
      post users_url, params: { user: { email: 'juan@gmail.com', username: 'juan09', password: 'test123' } }
    end
    assert_redirected_to products_path
  end

end
