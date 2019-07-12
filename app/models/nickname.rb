class Nickname < ApplicationRecord
  belongs_to :nicknameable, polymorphic: true
end
