class UsersController < ApplicationController
  
    def index
      users = User.all
      render :json => users.to_json
    end
  
    def create
      h = get_create_update_params(params[:user])
      user = User.new(h)
      if user.save
        render :json => user.to_json
      else
        #seems another object with same field is already present
        err_msg =  user.errors.full_messages
        render :json => {'errors' => ["User is already present.."]}.to_json, status: :bad_request
      end
    end
  
    def show
      user = User.where(:user_key => params[:id]).first
      if user.present?
        render :json => {'user' => user}.to_json
      else
        render :json => {'errors' => ["user is not present.."]}.to_json, status: :bad_request
      end
    end
  
    def update
      user = User.where(:user_key => params[:id]).first
      if user.present?
        h = get_create_update_params(params[:user])
        if user.update_attributes(h)
          render :json => {'user' => user}.to_json
        else
          render :json => {'errors' => [user.errors.full_messages]}.to_json, status: :bad_request
        end
      else
        render :json => {'errors' => ["user is not present.."]}.to_json, status: :bad_request
      end
    end
  
    def destroy
      user = User.where(:user_key => params[:id]).first
      if user.present?
        if user.destroy
          render :json => {}.to_json
        else
          render :json => {'errors' => [user.errors.full_messages]}.to_json, status: :bad_request
        end
      else
        render :json => {'errors' => ["User not found..."]}.to_json, status: :bad_request
      end
    end
  
    ##########################################################################################################################
    private
  
    def get_create_update_params(event)
        h = {}
        h[:user_name] = event[:user_name]
        h[:email] = event[:email]
        h[:phone] = event[:phone]
        h
    end
  
  end
  