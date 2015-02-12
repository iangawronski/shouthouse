class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :shouts

  has_many :relationships, foreign_key: "follower_id"
  has_many :following, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name: "Relationship"
  has_many :followers, through: :reverse_relationships, source: :follower

  validates :username, presence: true, uniqueness: true
            # format: { with: /[a-zA-Z0-9]{4,20}/, message: "Must be between 4 and 20 alphanumerics." }
  validates :password, presence: true
  validates :email, presence: true

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(user)
    self.following.where("relationships.followed_id" => user.id).destroy!
  end

  def follows?(user)
    self.following.include?(user)
  end
end
