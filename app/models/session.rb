class Session < ActiveRecord::Base
  validates :user_id, :session_token, presence: true
  validates :session_token, uniqueness: { scope: :user_id }

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.create_session(user)
    Session.create(user_id: user.id, session_token: generate_session_token)
  end

  def self.delete_by_token(session_token)
    session = Session.find_by(session_token: session_token)
    Session.destroy(session.id) if session
  end
end
