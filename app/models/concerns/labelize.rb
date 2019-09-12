# labelize.rb: -*- Ruby -*-  DESCRIPTIVE TEXT.
# 
#  Copyright (c) 2019 Brian J. Fox Opus Logica, Inc.
#  Author: Brian J. Fox (bfox@opuslogica.com)
#  Birthdate: Wed Sep 11 09:37:52 2019.
module Labelize
  extend ActiveSupport::Concern
  included do
    belongs_to :label,  optional: true

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
end
