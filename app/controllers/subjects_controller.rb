class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
    render json: @subjects.as_json
  end
end
