require 'utils/key_helper.rb'
class User
	include Mongoid::Document

  field :user_name, type: String
  field :email, type: String
  field :user_key, type: String
  field :phone, type: String
  
  validates :user_name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :user_key, uniqueness: true, presence: true

  def initialize(args={})
    super
    set_key
  end
  
  def generate_key
    self.user_key = KeyHelper.generate_key(User, :user_key, 5)
  end
  
  def set_key
    self.user_key = generate_key if self.user_key.nil?
  end

  def as_json(options={})
  	h = {
  		'email' => self.email,
      'user_key' => self.user_key,
      'user_name' => self.user_name,
      'phone' => self.phone
  	}
  	return h
  end

end