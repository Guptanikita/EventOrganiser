class Invitee
    include Mongoid::Document
  
    field :response, type: String #TODO:: make it enum..
    field :comment, type: String
  
    belongs_to :event, foreign_key: 'event_key'
    belongs_to :user, foreign_key: 'user_key'
  
    validates :event, presence: true
    validates :user, presence: true
    validates :response, presence: true
  
    before_save :before_save_method

    def initialize(args={})
      super
    end
    
    def before_save_method
        if self.response.nil?
            event = Event.where(:event_key => self.event_key).first
            from = event.from
            to = event.to
            overlapping_event_keys = Event.where(:from.lte => from, :to.gte => to).pluck(:event_key)
            invitee = Invitee.where(:event_key.in => overlapping_event_keys, :user_key => self.user_key, :response => "YES").count
            if count > 0
                self.response = "no"
            end
        end
    end

    def as_json(options={})
        h = {
           'title' => self.title,
        'from' => self.from,
        'to' => self.to,
        'description' => self.description,
        "all_day" => self.all_day,
        "response" => self.response
        }
        return h
    end
  
  end