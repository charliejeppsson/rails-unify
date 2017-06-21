Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_CLIENT_SECRET'],
  scope: 'r_basicprofile r_emailaddress',
  fields: ['id', 'email-address', 'first-name', 'last-name', 'headline', 'location', 'industry', 'picture-url', 'picture-urls', 'public-profile-url', 'positions'],
  secure_image_url: true
end
