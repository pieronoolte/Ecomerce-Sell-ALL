require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  def setup 
    @user = User.last
  end
  test "Welcome" do
    mail = UserMailer.with(user: @user).Welcome
    assert_equal "Welcome to Vendelo", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["no-reply@vendelo.com"], mail.from
    assert_match "Hey #{@user.username}, welcome to Vendelo. We hope you sell a lot!", mail.body.encoded
  end

end
