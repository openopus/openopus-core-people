class User < ApplicationRecord
  belongs_to :person
  accepts_nested_attributes_for :person
  has_many :credentials, as: :credentialed, dependent: :destroy
  accepts_nested_attributes_for :credentials
  has_and_belongs_to_many :organizations

  delegate :name, :name=, to: :person
  delegate :fname, :fname=, to: :person
  delegate :lname, :lname, to: :person
  delegate :minitial, :minitial, to: :person
  delegate :prefix, :prefix, to: :person
  delegate :suffix, :suffix, to: :person
  delegate :emails, :emails=, :email, :email=, to: :person
  delegate :phones, :phones=, :phone, :phone=, to: :person
  delegate :addresses, :addresses=, :address, :address=, to: :person
  delegate :birthdate, :birthdate=, to: :person
  delegate :age, :age=, to: :person
  
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
end
