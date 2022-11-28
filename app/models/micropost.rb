class Micropost < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :user
  validates :user_id, presence: true
  validates :body, presence: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :user
  has_rich_text :content
  # 🚅 add has_one associations above.
  default_scope -> { order(created_at: :desc) }
  # 🚅 add scopes above.
  
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
