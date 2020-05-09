class User < ApplicationRecord
    
    validates(:email, presence: true, uniqueness: true, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)

    has_secure_password
    
    has_many :posts
    has_many :comments
end
