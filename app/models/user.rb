# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  first_name                      :string(255)
#  last_name                       :string(255)
#  email                           :string(255)
#  password_digest                 :string(255)
#  admin                           :boolean          default(FALSE)
#  verified_at                     :datetime         default(NULL)
#  verification_token              :string(255)
#  verification_token_expiry_at    :datetime
#  forgot_password_token           :string(255)
#  forgot_password_token_expiry_at :datetime
#  remember_me_token               :string(255)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  prefered_location_id            :integer
#  stripe_user_id                  :string(255)
#
# Indexes
#
#  index_users_on_email                  (email)
#  index_users_on_forgot_password_token  (forgot_password_token)
#  index_users_on_prefered_location_id   (prefered_location_id)
#  index_users_on_remember_me_token      (remember_me_token)
#  index_users_on_verification_token     (verification_token)
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :orders

  attr_accessor :password_required

  scope :verified, ->{ where.not(verified_at: nil) }

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: {case_sensitive: false}, presence: true, format: {
    with:    REGEXP[:email],
    message: 'should have proper format.'
  }
  validates :password, length: { minimum: 6 }, if: 'password_required.present?'


  # after_destroy :ensure_an_admin_remains
  # before_destroy :check_if_can_destroy
  # before_update :check_if_can_update
  before_validation :set_password_required, on: :create
  before_create :genrate_email_verification_token
  after_commit :send_verification_email, on: :create

  # skip_callback :create, :before, :genrate_email_verification_token, if: -> { self.admin == true }
  # skip_callback :commit, :after, :send_verification_email, if: -> { self.admin == true }
  skip_callback :create, :before, :genrate_email_verification_token, if: 'admin?'
  skip_callback :commit, :after, :send_verification_email, if: 'admin?'


  def stripe_customer(stripeToken)
    if stripe_user_id
      customer = Stripe::Customer.retrieve(stripe_user_id)
    else
      customer = Stripe::Customer.create(
        email: email,
        source: stripeToken
      )
      self.stripe_user_id = customer.id
      save!
    end
    customer
  end

  def verify_email!
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expiry_at = nil
    save!
  end

  def verified?
    verified_at.present?
  end

  def verification_token_valid?
    verification_token_expiry_at > Time.current
  end

  def forgot_password_token_valid?
    forgot_password_token_expiry_at > Time.current
  end

  def fullfill_forgot_password_token!
    self.forgot_password_token = generate_token(:forgot_password_token)
    self.forgot_password_token_expiry_at = CONSTANTS['token_validity_period'].hours.from_now
    save!
    UserNotifier.forgot_password_email(self).deliver_now
  end

  def genrate_remember_me_token!
    self.remember_me_token = generate_token(:remember_me_token)
    save!
  end

  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password
    self.password_confirmation = new_password_confirmation
    set_password_required
    self.forgot_password_token = nil
    self.forgot_password_token_expiry_at = nil
    save!
  end

  def clear_remember_me_token!
    self.remember_me_token = nil
    save!
  end

  def set_prefered_location(location_id)
    self.prefered_location_id = location_id
    save!
  end

  private

    def set_password_required
      self.password_required = true;
    end

    def genrate_email_verification_token
      self.verification_token = generate_token('verification_token')
      debugger
      self.verification_token_expiry_at = CONSTANTS['token_validity_period'].hours.from_now
    end

    def generate_token(token_type)
      token = loop do
        random_secure_token = SecureRandom.urlsafe_base64(nil, false)
        break random_secure_token unless User.exists?(token_type => random_secure_token)
      end
      token
    end

    def send_verification_email
      UserNotifier.verification_email(self).deliver_now
    end

    # def check_if_can_destroy
    #   check_is_not_admin
    # end

    # def check_if_can_update
    #   check_is_not_admin
    # end

    # def check_is_not_admin
    #   if email == 'admin@depot.com' || email_was == 'admin@depot.com' 
    #     errors[:base] << 'Can`t update or delete admin!'
    #     return false
    #   else
    #     return true
    #   end
    # end

    # def ensure_an_admin_remains
    #   if User.count.zero?
    #     raise "Can't delete last user"
    #   end
    # end

end
