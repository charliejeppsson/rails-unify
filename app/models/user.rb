class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:linkedin]

  has_many :events, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :events_to_attend, through: :attendances, source: :event
  has_many :messages, dependent: :destroy
  has_many :chatrooms, dependent: :destroy
  has_many :chatroomusers, dependent: :destroy

  def self.find_for_linkedin_oauth(auth)
    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:location] = auth.info.location.name
    user_params[:picture] = auth.info.image
    user_params[:url] = auth.info.urls.public_profile
    user_params[:headline] = auth.extra.raw_info.headline
    user_params[:industry] = auth.extra.raw_info.industry
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end

end
