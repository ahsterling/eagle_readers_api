class Book < ActiveRecord::Base
  has_many :book_subjects
  has_many :subjects, through: :book_subjects
  validates :title, presence: true

  def add_subject(subject)
    update_attributes subject_array: subject_array + [ subject ]
    new_subject = Subject.find_by(name: subject)
    if new_subject
      BookSubject.create(book_id: self.id, subject_id: new_subject.id)
    else
      new_subject = Subject.create(name: subject)
      BookSubject.create(book_id: self.id, subject_id: new_subject.id)
    end
  end

end
