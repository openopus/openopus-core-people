class Email < ApplicationRecord
  include Labelize
  belongs_to :emailable, polymorphic: true, optional: true
  accepts_nested_attributes_for :label
  before_create :default_label
  before_save :canonicalize

  def self.canonicalize(addr)
    candidate = addr.strip.downcase if not addr.blank?
    candidate ||= addr
  end

  def canonicalize
    self.address = self.class.canonicalize(self.address)
  end

  def default_label
    self.label = Label.get("Work")
  end

end
