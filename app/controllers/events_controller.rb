class EventsController < ApplicationController
  
    def index
      events = Event.all
      render :json => events.to_json
    end
  
    def create
      h = get_create_update_params(params[:event])
      event = Event.new(h)
      if event.save
        # send invites to user..
        EventHepler.generate_invites(event.event_key, params[:user_keys])
        render :json => event.to_json
      else
        #seems another object with same field is already present
        err_msg =  event.errors.full_messages
        render :json => {'errors' => ["Event is already present.."]}.to_json, status: :bad_request
      end
    end
  
    def show
      event = Event.where(:event_key => params[:id]).first
      if event.present?
        render :json => {'event' => event}.to_json
      else
        render :json => {'errors' => ["event is not present.."]}.to_json, status: :bad_request
      end
    end
  
    def update
      event = Event.where(:event_key => params[:id]).first
      if event.present?
        h = get_create_update_params(params[:event])
        if event.update_attributes(h)
          # update user invitation
          EventHepler.generate_invites(event.event_key, params[:user_keys])
          render :json => {'event' => event}.to_json
        else
          render :json => {'errors' => [event.errors.full_messages]}.to_json, status: :bad_request
        end
      else
        render :json => {'errors' => ["event is not present.."]}.to_json, status: :bad_request
      end
    end
  
    def destroy
      event = Event.where(:event_key => params[:id]).first
      if event.present?
        if event.destroy
          render :json => {}.to_json
        else
          render :json => {'errors' => [event.errors.full_messages]}.to_json, status: :bad_request
        end
      else
        render :json => {'errors' => ["Event not found..."]}.to_json, status: :bad_request
      end
    end
  
    ##########################################################################################################################
    private
  
    def get_create_update_params(event)
        h = {}
        h[:title] = event[:tile]
        #TODO :: Timezone need to be handle..
        h[:from] = Time.use_zone("UTC") {Time.zone.parse(event[:from])}
        h[:to] = Time.use_zone("UTC") {Time.zone.parse(event[:to])}
        h[:description] = event[:description]
        h[:all_day] = event[:all_day]
        h
    end
  
  end
  