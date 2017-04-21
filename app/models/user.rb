class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, format: {with: VALID_EMAIL_REGEX},
    presence: true, length: {maximum: 255},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}

  has_secure_password

  before_save :downcase_email

  private
  def downcase_email
    self.email = email.downcase
  end
end
