class Credential < ApplicationRecord
  belongs_to :credentialed, polymorphic: true
  belongs_to :email

  before_validation :grab_email_from_credentialed

  def grab_email_from_credentialed
    debugger
  end
end
