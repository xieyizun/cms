class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :remember_token

  has_secure_password

  has_many :articles, dependent: :destroy

  validates_presence_of :name, :email, :password, :password_confirmation
  validates_uniqueness_of :name, :email

  validates_length_of :name, maximum: 25
  validates_length_of :email, maximum: 50
  validates_length_of :password, minimum: 6

  NAME_FORMAT = /^[0-9a-z\-_]*$/i
  EMAIL_FORMAT = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :name, with: NAME_FORMAT
  validates_format_of :email, with: EMAIL_FORMAT

  validates_confirmation_of :password

  before_save :create_remember_token


  def self.login_authenticate(params)
    @user
    if params[:session][:name_or_email] =~ NAME_FORMAT
      @user = User.find_by_name(params[:session][:name_or_email])
    else
      @user = User.find_by_email(params[:session][:name_or_email])
    end
    @user = nil unless (@user && @user.authenticate(params[:session][:password]))
    @user
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
