class Book < ActiveRecord::Base
  validates :title, presence: true

  def add_subject(subject)
    update_attributes subject_array: subject_array + [ subject ]
  end

end
