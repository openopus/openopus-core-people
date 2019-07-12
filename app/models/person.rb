class Person < ApplicationRecord
  has_many :users
  has_many :nicknames, as: :nicknameable
  has_many :addresses, as: :addressable
  has_many :phones, as: :phoneable
  has_many :emails, as: :emailable

  accepts_nested_attributes_for :nicknames
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :phones
  accepts_nested_attributes_for :emails

  def self.lookup(name)
    person   = self.find_by(self.name_components(name))
    person ||= self.includes(:nicknames).joins(:nicknames).find_by("nicknames.nickname" => name)
    if not person
      people = self.all.collect do |p|
        [p.id, [(p.fname[0] || ""), (p.minitial[0] || ""), (p.lname[0] || "")].join("").upcase]
      end
      people.each do |parry|
        if parry[1] == name.upcase
          person = self.find(parry[0])
          break
        end
      end
    end

    if not person
      addr = Email.where(emailable_type: self.name.to_s, address: name.downcase).first
      person = addr.people.first if addr
    end

    person
  end

  def user
    self.users.first
  end

  def user=(u)
    self.users = [u]
  end

  def email
    self.emails.first
  end

  def email=(address)
    e = self.emails.where(address: address.downcase.strip).first_or_initialize() if not address.blank?
    emails << e if not emails.include?(e)
    e
  end
    
  def phone=(number)
    if number.is_a?(Phone)
      phones << number unless phones.include?(number)
      return
    end

    if not number.blank?
      p = phones.first rescue nil
      p ||= Phone.create(:label => Label.get("Work"))
      phones << p unless phones.include?(p)
      p.number = number
      p.save
    end
  end

  def phone
    p = self.phones.find_by(label: Label.get("Work"))
    p ||= self.phones.first
    p
  end

  def self.is_name_prefix?(text)
    possibles = %w(mr mrs ms miss dr professor prof)
    result = possibles.include?(text.gsub(/[.]*/, "").downcase) if text.present?
  end

  def self.is_name_suffix?(text)
    possibles = %w(esq phd jr iii ii)
    result = possibles.include?(text.gsub(/[.]*/, "").downcase) if text.present?
  end

  def self.name_components(name)
    res = {}
    component = ""
    components = name.gsub(/,/, " ").gsub(/  /, " ").split(" ") rescue [name]
    num_parts = components.length
    component = components.shift

    # What kind of thing is this?
    if is_name_prefix?(component)
      res[:prefix] = component
      res[:fname] = components.shift
    else
      res[:fname] = component
    end

    # Next up, middle initial or last name.
    # If only one word remains, that's the last name
    if components.length == 1
      res[:lname] = components.shift
    elsif components.length > 0
      # At least 2 words remain. We might have middle names, prefixes, suffixes, etc.
      components.reverse!
      component = components.shift
      if is_name_suffix?(component)
        res[:suffix] = component
        res[:lname] = components.shift
      else
        res[:lname] = component
      end
      res[:minitial] = components.shift
    end

    res[:minitial] = res[:minitial].gsub(/[.]/, "") if res[:minitial].present?
    res
  end

  def name
    components = []

    if prefix.present?
      if not prefix.include?(".")
        components << "#{prefix}."
      else
        components << prefix
      end
    end

    components << fname if fname.present?

    if minitial.present?
      if minitial.length < 2
        components << "#{minitial}."
      else
        components << minitial
      end
    end

    components << lname if lname.present?
    components << ", #{suffix}" if suffix.present?
    components.join(" ").strip.gsub(/ ,/, ",")
  end

  def name=(incoming_name)
    components = self.class.name_components(incoming_name)
    self.prefix = components[:prefix]
    self.fname = components[:fname]
    self.minitial = components[:minitial]
    self.lname = components[:lname]
    self.suffix = components[:suffix]
  end

  def age
    ((Date.today - self.birthdate).to_i / 365) if self.birthdate.present?
  end

  def age=(new_age)
    self.birthdate = (Date.today - (rand(Date.today.month - 1))) - new_age.years
    self.birthdate
  end

  def address
    a = self.addresses.where(label: Label.get("Work")).first
    a ||= self.addresses.first
  end

  def address=(new_address)
    if new_address.is_a?(Address)
      self.addresses << new_address unless self.addresses.include?(new_address)
    elsif %w(Integer Fixnum Bignum).include?(new_address.class.to_s)
      a = Address.find(new_address)
      self.addresses << a unless self.addresses.include?(a)
    else
      parsed = Address.parse(new_address)
      current = addresses.where(line1: parsed.line1).first
      current ||= Address.new
      parsed.attributes.each {|key, val| current.send((key + "=").to_sym, val) unless val == nil }
      current.save
      self.addresses << current unless self.addresses.include?(current)
    end
    self.save
  end

  def self.find_or_create_by(hash)
    options = hash.clone
    if options.has_key?(:name)
      options = options.merge(self.name_components(options[:name]))
      options.delete(:name)
    end
    super(options)
  end

  def self.find_by_nickname(nick)
    person = self.includes(:nicknames).joins(:nicknames).find_by("nicknames.nickname" => nick)
  end

  def self.find_by_email(addr)
    e = Email.find_by_address(addr)
    e.person if e
  end

  def self.find_by_phone_number(number)
    p = Phone.find_by_number(number)
    p.person if p
  end

  def self.find_by_address(string)
    a = Address.find_by_address(string)
    a.person if a
  end

  def add_phone(number, label="Home")
    if self != self.class.find_by_phone_number(number)
      p = Phone.create(number: number, label: Label.get(label))
      phones << p
    end
    p = Phone.find_by_number(number)
  end

  def add_email(address, label="Home")
    if self != self.class.find_by_email(address)
      e = Email.create(address: address, label: Label.get(label))
      emails << e
    end
    e = Email.find_by(address: address)
  end

  def add_address(address_line, label="Home")
    if self != self.class.find_by_address(address_line)
      a = Address.parse(address_line); a.save
      a.label = Label.get(label)
      a.save
      addresses << a
    end
    a = Address.find_by_address(address_line)
  end


end
