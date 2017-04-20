class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, presence: true
  validates :password, presence: { limit: 6, allow_nil: true }
  validates :user_name, uniqueness: true

  has_many :cats,
    primary_key: :id,
    foreign_key: :owner_id,
    class_name: :Cat,
    dependent: :destroy

  has_many :rental_requests,
    primary_key: :id,
    foreign_key: :requester_id,
    class_name: :CatRentalRequest,
    dependent: :destroy

  has_many :sessions,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Session,
    dependent: :destroy

  def self.find_by_credentials(username, password)
    user = User.find_by(user_name: username)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  def self.find_by_session_token(session_token)
    User.joins(:sessions).where('sessions.session_token = ?', session_token)
        .first
  end

  def ensure_session
    @session ||= Session.create_session(self)
  end

  def create_session!
    @session = Session.create_session(self)
    @session.session_token
  end

  def delete_session!
    @session.destroy
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def save_plus_session
    User.transaction do
      self.save!
      ensure_session
    end
  end
end
