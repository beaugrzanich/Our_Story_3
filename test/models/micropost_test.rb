require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    # This code is not idiomatically correct.
    @micropost = Micropost.new(body: "Lorem ipsum", user_id: @user.id)
  end
  test "should be valid" do
    assert @micropost.valid?
  end
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end 
  test "content should be present" do
    @micropost.body = "   "
    assert_not @micropost.valid?
  end
end
