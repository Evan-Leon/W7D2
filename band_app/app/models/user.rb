# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#
class User < ApplicationRecord

    validates :email, :password_digest, :session_token, presence: true 

    after_initialize :ensure_session_token 

    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        if user && user.is_password?(password)
            user  
        else  
            nil
        end
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password  
    end

    def is_password?(password)
        password_obj = BCrypt::Password.new(self.password_digest)
        password_obj.is_password?(password)
    end

    def password 
        @password 
    end


    def reset_session_token

        self.session_token = User.generate_session_token
        self.save!
        self.session_token 

    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end
end