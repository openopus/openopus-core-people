class Email < ApplicationRecord
  belongs_to :label
  belongs_to :emailable

  accepts_nested_attributes_for :label
end
