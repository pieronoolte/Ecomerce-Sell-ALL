class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, presence: true, uniqueness: true, 
    length: {minimum:3, maximum:15},
    format: {
        with: /\A[a-z0-9\-A-Z]+\z/,
        message: :invalid
    }
    validates :password, length: { minimum: 6}, if: :password_digest_changed?
    has_many :products, dependent: :destroy
    has_many :favorites, dependent: :destroy

    before_save :downcase_attributes

    private

    def downcase_attributes 
        self.username = username.downcase
        self.email = email.downcase
    end

    
end
