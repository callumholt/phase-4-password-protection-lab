class UsersController < ApplicationController
   
    def index
        users = User.all
        render json: users
      end
    
    def show
        user = User.find_by(id: session[:user_id])
        if user
          render json: user
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
    end
    

    def create
        @user = User.create(user_params)
        puts "User Params: #{user_params}"
        puts "New User: #{@user}"
        session[:user_id] = @user.id

        if @user.save
            render json: @user
            session[:current_user_id] = @user.id

          else
            puts "Validation Errors: #{@user.errors.full_messages}"

            render :new, status: :unprocessable_entity
        end

    end
    
    private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end

    
end

# username: "mario", password_digest:"2hj3kh12jh3"
# create a new user; 
# save their hashed password in the database; 
# save the user's ID in the session hash; and return the user object in the JSON response.

# if i comment out "has_secure_password" from the user model it seems to work however the password in the db becomes "null"
# If i add the params in directly inline then it sends to db fine, but the password is NOT hashed
# when i put "user_params" in, it returns "Completed 422 Unprocessable Entity" and does not go to db
# I have even tried recloning the repo to start again, but got to the exact same problem
# 
#
