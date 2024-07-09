class UsersController < ApplicationController
    skip_before_action :protect_pages, only: [:show]


    def show 
        @user = User.find_by!(username: params[:username])
        # @pagy, @products = pagy_countless(FindProducts.new.call({ user_id: @user.id}), items: 5)
    end
end