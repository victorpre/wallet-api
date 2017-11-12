class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable
  validates :name, presence: true
  validates :auth_token, uniqueness: true, allow_nil: true

  before_create :generate_auth_token

  def generate_auth_token
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
    self.auth_token
  end

  def expire_auth_token!
    self.update_attributes(auth_token: nil)
  end
end
