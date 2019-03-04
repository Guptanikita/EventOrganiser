# README

This README would normally document whatever steps are necessary to get the
application up and running.

1. For running the app 
    start mongo server #as db is mongodb
    bundle install #for installing all dependencies
    rails s #start the server

2. Database Design

    There are three models :
        User : for user's metadata which has username, email and phone number.

        Event : for storing event data which has title, from , to , description , user_key(which is organiser of an event), all_day (flag which decides the event is for all_day or not), status of an event.

        Invitee : for storing invitees information which has event_key, user_key and response of that user(rsvp)

3. Scripts for creating users and events
    rake load_config:load_users  #for users creation
    rake load_config:load_events #for events creation

4. API Summary