class User < ApplicationRecord
  belongs_to :person
  accepts_nested_attributes_for :person
  has_and_belongs_to_many :organizations

  PERSON_SETTERS = [:name=,:fname=,:lname=,:minitial=,:prefix=,:suffix=,:emails=,:phones=,:addresses=,:birthdate=,:age=,:nationality=]
  PERSON_GETTERS = [:name,:name=,:fname,:lname,:minitial,:prefix,:suffix,:emails,:phones,:addresses,:birthdate,:age,:nationality]
  PERSON_DELEGATES  = PERSON_SETTERS + PERSON_GETTERS
  PERSON_STRINGS = PERSON_DELEGATES + PERSON_DELEGATES.collect {|x| x.to_s}

  delegate(*PERSON_DELEGATES, to: :person)
  
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
    if not attr.keys.to_set.intersection(PERSON_STRINGS).empty?
      self.person = Person.new
    end
    super(attr)
  end

end
