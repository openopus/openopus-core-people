class Phone < ApplicationRecord
  belongs_to :label
  belongs_to :phoneable
end
