class Authentication::UsersController < ApplicationController
    skip_before_action :protect_pages
    def new 
        @user = User.new
    end

    def create 
        @user = User.new(user_params)
        
    
        if @user.save
            FetchCountryJob.perform_later(@user.id, request.remote_ip)
            UserMailer.with(user: @user).Welcome.deliver_later
            session[:user_id] = @user.id
            redirect_to products_path, notice: t('.created')
        else
            if @user.errors[:username].include?("ya está en uso")
                flash.now[:alert] = "El nombre de usuario ya está en uso. Por favor, elige otro."
            end
            render :new, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :username, :password)
    end
end