class User < ApplicationRecord
    has_many :events, class_name: 'Event', foreign_key: 'creator_id', dependent: :delete_all
    has_many :attendances
    has_many :events_as_attendee, through: :attendances, source: "event"
  
    validates :name, presence: true, length: { maximum: 24 },
              uniqueness: { case_sensitive: false }
  end
  