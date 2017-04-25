class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token

  validates :name, presence: true, length: {maximum: 50}
  validates :email, format: {with: VALID_EMAIL_REGEX},
    presence: true, length: {maximum: 255},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  has_secure_password

  before_save :downcase_email

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def current_user? user
    self == user
  end

  def remember
    self.remember_token = self.class.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticate? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  private
  def downcase_email
    self.email = email.downcase
  end
end
