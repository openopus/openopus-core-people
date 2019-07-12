class Organization < ApplicationRecord
  has_many :nicknames, as: :nicknameable
  accepts_nested_attributes_for :nicknames
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users

  def self.lookup(thing)
    candidate   = self.where(name: thing).first
    candidate ||= self.includes(:nicknames).joins(:nicknames).find_by("nicknames.nickname" => thing)
  end

end
