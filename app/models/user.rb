# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_member_token

  # Validations
  validates :name, presence: true   # Same as: validates(:name, presence: true) - make sure a non-blank value is provided
  validates :name, length: { maximum: 50 }

  validates :email, presence: true  # Same as: validates(:email, presence: true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # Private methods
  private

    # Member token
    def create_member_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
