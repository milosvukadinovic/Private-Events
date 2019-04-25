class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :attendances
  has_many :attendees, through: :attendances, source: "user"

  scope :past, -> { where("date < ?", DateTime.now) }
  scope :future, -> { where("date > ?", DateTime.now) }

  validates :title, presence: true, length: { maximum: 36 }
  validates :info, length: { maximum: 36 }
  validates :location, presence: true, length: { maximum: 36 }
  validates :date, presence: true
  validates :creator_id, presence: true
end
