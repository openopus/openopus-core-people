class Email < ApplicationRecord
  include Labelize
  belongs_to :emailable, polymorphic: true, optional: true
  accepts_nested_attributes_for :label
  before_create :default_label
  before_save :canonicalize

  VALID_EMAIL_FORMAT_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_format_of :address, with: VALID_EMAIL_FORMAT_REGEX, :on => :create

  def self.canonicalize(addr)
    candidate = addr.strip.downcase if not addr.blank?
    candidate ||= addr
  end

  def canonicalize
    self.address = self.class.canonicalize(self.address)
  end

  def self.valid_format?(addr)
    return (addr =~ VALID_EMAIL_FORMAT_REGEX) != nil
  end
  
  def default_label
    self.label = Label.get("Work")
  end

end
