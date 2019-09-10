class User < ApplicationRecord
  belongs_to :person
  accepts_nested_attributes_for :person
  has_and_belongs_to_many :organizations

  NAME_DELEGATES  = [:name,:fname,:lname,:minitial,:prefix,:suffix,:emails,:phones,:addresses,:birthdate,:age] +
                    [:name=,:fname=,:lname=,:minitial=,:prefix=,:suffix=,:emails=,:phones=,:addresses=,:birthdate=,:age=]

  delegate(*NAME_DELEGATES, to: :person)
  
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
    if not attr.keys.to_set.intersection(NAME_DELEGATES).empty?
      self.person = Person.new
    end
    super(attr)
  end

end
