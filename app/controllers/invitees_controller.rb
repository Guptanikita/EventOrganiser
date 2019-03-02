class InviteesController < ApplicationController
  
    def index
      invitees = Invitee.all
      user_key = params[:user_key]
        if user_key.present?
            invitees = invitees.where(:user_key => user_key)
        end
        event_key = params[:event_key]
        if event_key
            invitees = invitees.where(:event_key => event_key)
        end
      render :json => invitees.to_json
    end
  
    def show
      invitee = Invitee.where(:invitee_key => params[:id]).first
      if invitee.present?
        render :json => {'invitee' => invitee}.to_json
      else
        render :json => {'errors' => ["invitee is not present.."]}.to_json, status: :bad_request
      end
    end
  
    def update
      invitee = Invitee.where(:invitee_key => params[:id]).first
      if invitee.present?
        #chek for expired event..
        event = Event.where(:event_key => invitee.event_key).first
        if event.isExpired()
            render :json => {'errors' => ["Event has been expired."]}.to_json, status: :bad_request
        end
        invitee.reponse = params["response"]
        if invitee.update
          render :json => {'invitee' => invitee}.to_json
        else
          render :json => {'errors' => [invitee.errors.full_messages]}.to_json, status: :bad_request
        end
      else
        render :json => {'errors' => ["You are not allowed to update this invitaion."]}.to_json, status: :bad_request
      end
    end
  
    def destroy
      invitee = Invitee.where(:invitee_key => params[:id]).first
      if invitee.present?
        if invitee.destroy
          render :json => {}.to_json
        else
          render :json => {'errors' => [invitee.errors.full_messages]}.to_json, status: :bad_request
        end
      else
        render :json => {'errors' => ["Invitee not found."]}.to_json, status: :bad_request
      end
    end
  end
  