require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do 
    login
    @productLike = products(:megadrive)
    @productUnlike = products(:switch)
  end

  test "should return my favorite" do
    get favorites_url

    assert_response :success
   
  end

  test "should create favorite" do

    assert_difference('Favorite.count', +1) do
        post favorites_url(product_id: @productLike.id)
    end
    
    assert_redirected_to product_path(@productLike)
  end

  test "should unfavorite" do

    assert_difference('Favorite.count', -1) do
        delete favorite_url(@productUnlike.id)
    end
    
    assert_redirected_to product_path(@productUnlike)
  end
end