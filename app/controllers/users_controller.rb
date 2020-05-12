class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
        if @user.save
          flash.delete(:warning)
          redirect_to posts_path
        else
          flash[:warning] = "unable to create user"
          render :new
        end
        
    end

    def edit
        @user = current_user 
    end

    def edit_password
        @user = current_user 
    end

    def update
        user_params = params.require(:user).permit(:first_name, :last_name, :email)
        @user = current_user
        if @user.update user_params
            flash[:success] = "info updated"
            redirect_to root_path
        else
            render :edit
        end
    end
    
    def update_password
        @user = current_user
        user_params = params[:user]
        new_p = user_params[:new_password]
        new_c = user_params[:new_password_confirmation]
        cur_p = user_params[:current_password]

        if (new_p.size < 6)
            flash[:danger] = "password should be at least 6 characters"
            render :edit_password
            return
        end

        if (current_user.authenticate(cur_p))
            if (cur_p == new_p)
                flash[:danger] = "new password should be different than current password"
                render :edit_password
            elsif (new_p == new_c) # check if new password and confirmation are same
                if @user.update({password: new_p})
                    # because of has_secure_password adding a password attribute to a user will automatically update and hash a password_digest attribute
                    # has_secure_password will also have a validation to make sure the attributes `password` and `password_digest` are the same
                    flash[:success] = "password updated"
                    redirect_to root_path
                else
                    flash[:danger] = "password not updated"
                    render :edit_password
                end
            end
        else
            flash[:danger] = "wrong current password"
            render :edit_password
        end
    end
end
