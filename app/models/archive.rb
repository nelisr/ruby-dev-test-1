# annotate
# ---
# == Schema Information
#
# Table name: archives
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  directory_id :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_archives_on_directory_id           (directory_id)
#  index_archives_on_name_and_directory_id  (name,directory_id) UNIQUE
#  index_archives_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (directory_id => directories.id)
#  fk_rails_...  (user_id => users.id)
#
# ---
class Archive < ApplicationRecord
  # Attachments
  has_one_attached :file

  # Validations
  # ---
  validates :name, presence: true, uniqueness: { scope: :directory_id }
  validates :file, presence: true

  # Associations
  # ---
  belongs_to :directory
  belongs_to :user

  # Delegate Attributes
  delegate :url, to: :file

  # Virtual Attributes
  # ---
  def path
    return name unless directory

    [directory.path, name].join('/')
  end
end
