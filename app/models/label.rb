class Label < ApplicationRecord

  def self.instantiate_defaults
    %w(Home Work Cell).each {|v| self.get(v)}
  end

  def self.get(name, lang="en")
    self.where(value: name, lang: lang).first_or_create
  end

end
