class EventHelper
    def self.generate_invites(event_key, user_keys)
        if event_key.present? and users.length > 0
            invitees = []
            user_keys.each do |user_key|
                invitee = Invitee.new(:event_key => event_key, :user_key => user_key)
                invitee.save
            end
        end
    end 
end