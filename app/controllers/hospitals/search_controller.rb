class Hospitals::SearchController < ApplicationController
  def search
    @content = params[:search][:content]
    @hospitals = Hospital.search(@content)
  end
end
