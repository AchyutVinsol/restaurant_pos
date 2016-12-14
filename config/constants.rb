if Rails.env.development? or Rails.env.test?
  CONSTANTS = YAML.load_file('./config/constants.yml')[Rails.env]
else
  CONSTANTS = {token_validity_period: ENV.fetch('TOKEN_VALIDITY_PERIOD'), default_email: ENV.fetch('EMAIL_ID'), email_id: ENV.fetch('EMAIL_ID'), email_password: ENV.fetch('EMAIL_PASSWORD')}
end

REGEXP = {
  url: /\Ahttps?:\/\/(www \.)?[-A-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-A-Z0-9@:%_\+.~#?&\/=]*)\z/i,
  email: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
  digit: /\d/
}
MINIMUM_SHIFT_HOURS = 6
MEAL_VALIDITY_MINUTES = 5
CANCELATION_BUFFER_MINUTES = 30
