class EventHelper
    #users_rsvp : [{user_key: "user_key", "rsvp" :yes}]
    def self.generate_invites(event_key, users_rsvp)
        if event_key.present? and users.length > 0
            invitees = []
            users_rsvp.each do |user_rsvp|
                user_key = user_rsvp.user_key
                rsvp = user_rsvp.rsvp
                invitee = Invitee.new(:event_key => event_key, :user_key => user_key, :response => rsvp)
                invitee.save
            end
        end
    end 
end