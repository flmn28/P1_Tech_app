class Post < ApplicationRecord

  validates :title, presence: true, length: { maximum: 30 }
  validates :outline, presence: true, length: { maximum: 50 }
  validates :detail, presence: true, length: { maximum: 200 }
  validates :published, inclusion: {in: [true, false]}
  validates :status, presence: true
  validates :num_of_planner, presence: true
  validates :num_of_engineer, presence: true
  validates :num_of_designer, presence: true
  validates :num_of_marketer, presence: true

  belongs_to :template
  has_many :team_members

  mount_uploader :image, ImageUploader

  enum status: { planning: 0, development: 1, release: 2 }
end