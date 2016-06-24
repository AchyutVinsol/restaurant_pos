# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  comment         :string(255)
#  rating          :integer
#  user_id         :integer
#  reviewable_id   :integer
#  reviewable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_reviews_on_reviewable_type_and_reviewable_id  (reviewable_type,reviewable_id)
#  index_reviews_on_user_id                            (user_id)
#

class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :reviewable, polymorphic: true

  validates :comment, :rating, presence: true
  validates :comment, length: { in: 1..200 }
  validates :rating, numericality: { only_integer: true, greater_than: 0, lesser_than: 6 }
  validates :user_id, uniqueness: {scope: [:reviewable_type, :reviewable_id]}

end
