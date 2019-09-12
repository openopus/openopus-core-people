class User < ApplicationRecord
  belongs_to :person
  accepts_nested_attributes_for :person
  has_and_belongs_to_many :organizations

  PERSON_ATTR = %w(name fname lname minitial prefix suffix email phone emails phones addresses birthdate age nationality language)
  PERSON_SYMS = PERSON_ATTR.collect {|x| [x.to_sym, (x + "=").to_sym] }.flatten
  PERSON_SET  = PERSON_SYMS + PERSON_ATTR
  
  delegate(*PERSON_SYMS, to: :person)
  
  def self.lookup(item)
    person = Person.lookup(item)
    (person.send self.name.downcase.to_sym) if person
  end

  def organization=(org)
    self.organizations << org if not self.organizations.include?(org)
  end

  def organization
    self.organizations.order(created_at: :desc).first
  end
 
  def assign_attributes(attr)
    if not attr.keys.to_set.intersection(PERSON_SET).empty?
      self.person = Person.new
    end
    super(attr)
  end
end
