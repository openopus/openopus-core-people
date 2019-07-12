class Credential < ApplicationRecord
  belongs_to :credentialable
  belongs_to :email
end
