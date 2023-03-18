class User < ApplicationRecord
  include Users::Base
  # 🚅 add concerns above.
  # belongs_to :team
  # I am unsure why I added the line above originally, but that line appears to have broken signups
  # committing to add more comments in the future to avoid confusion
  # 🚅 add belongs_to associations above.
  
  has_many :microposts, dependent: :destroy
  
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.
  
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
