class Credential < ApplicationRecord
  has_secure_password
  belongs_to :credentialed, polymorphic: true

  # We point to an enail that actually polymorphically belongs to a different thing.
  # Which is great.  So don't declare this to be a polymorphic relationship.  It isn't.
  belongs_to :email
  before_validation :grab_email_from_credentialed

  # validates :password, length: { minimum: 8 }, on: :create

  def grab_email_from_credentialed
    self.email ||= self.credentialed.email
  end
end
