class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, :last_name, presence: true
  validates_uniqueness_of :email, case_sensitive: false
  validates :email, format: {
    with:    REGEXP[:email],
    message: 'should have proper format.'
  }

  # after_destroy :ensure_an_admin_remains
  # before_destroy :check_if_can_destroy
  # before_update :check_if_can_update
  # before_create :generate_token
  before_create :genrate_email_verification_token
  after_commit :send_verification_email, on: :create

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

  private

    def genrate_email_verification_token
      self.verification_token = generate_token('verification_token')
      self.verification_token_expiry_at = Time.current + 6.hours
    end

    def generate_token(token_type)
      token = loop do
        random_secure_token = SecureRandom.urlsafe_base64(nil, false)
        break random_secure_token unless User.exists?(token_type.to_sym => random_secure_token)
      end
      token
    end

    def send_verification_email
      UserNotifier.verification_email(self).deliver
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
