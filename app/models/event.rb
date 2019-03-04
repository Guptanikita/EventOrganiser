require "utils/key_helper.rb"
class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :from, type: Time
  field :to, type: Time
  field :description, type: String
  field :all_day, type: Boolean
  field :event_key, type: String
  field :status, type: String # Status of event, Cancelled, Posponed, Preponed, Finished
  

  belongs_to :user, foreign_key: 'user_key', optional: true

  validates :from, presence: true
  validates :to, presence: true

  index({ user_key: 1, from: -1, to: -1}, background: true)

  before_save :before_save_method

  def initialize(args={})
    super
    set_key
  end

  def generate_key
    self.event_key = KeyHelper.generate_key(Event, :event_key, 5)
  end
  
  def set_key
    self.event_key = generate_key if self.event_key.nil?
  end

  def isExpired
    if event.status == "FINISHED" || self.from < Time.now.utc
        return true
    end
    return false 
  end
  
  def before_save_method
    if self.to < Time.now.utc
      self.status = "FINISED"
    end
    self.status = "SCHEDULED"
  end


  def as_json(options={})
  	h = {
  	   'title' => self.title,
      'from' => self.from,
      'to' => self.to,
      'description' => self.description,
      "all_day" => self.all_day
  	}
  	return h
  end

end