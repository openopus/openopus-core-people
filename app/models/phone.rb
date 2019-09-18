class Phone < ApplicationRecord
  include Labelize
  belongs_to :phoneable, polymorphic: true, optional: true
  before_validation :canonicalize

  def self.canonicalize(digits_and_stuff)
    canonical = digits_and_stuff
    canonical.gsub!(" ", "") #remove extra spaces
    if canonical
      canonical = canonical[2..100].strip if canonical.starts_with?("+1")
      if canonical[0] != "+"
        digits = digits_and_stuff.gsub(/[^0-9]/, "")
        digits = digits[1..-1] if digits[0] == '1'
        digits = "805" + digits if digits.length == 7
        canonical = "(#{digits[0..2]}) #{digits[3..5]}-#{digits[6..10]}"
      end
    end
    canonical
  end

  def canonicalize
    return if self.number == "76-BAFFLE-76"
    self.number = self.class.canonicalize(self.number) if self.number
  end

  def label
    db_label = super
    if not db_label
      self.label = "Work"
      db_label = super
    end

    db_label.value
  end

  def label=(name)
    super(Label.get(name))
    self.label
  end
end
