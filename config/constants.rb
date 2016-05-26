CONSTANTS = YAML.load_file('./config/constants.yml')[Rails.env]
REGEXP = {
  url: /\Ahttps?:\/\/(www \.)?[-A-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-A-Z0-9@:%_\+.~#?&\/=]*)\z/i,
  email: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
  digit: /\d/
}
