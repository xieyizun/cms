class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :remember_token

  has_secure_password

  has_many :articles, dependent: :destroy

  validates_presence_of :name, :email, :password, :password_confirmation
  validates_uniqueness_of :name, :email

  validates_length_of :name, maximum: 25
  validates_length_of :email, maximum: 50
  validates_length_of :password, minimum: 6

  validates_format_of :name, with: /^[0-9a-z\-_\.@]*$/i
  validates_format_of :email, with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  validates_confirmation_of :password

  before_save :create_remember_token

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
