class BooksController < ApplicationController
  def index
    @pagy, @books = pagy Book.order(created_at: :desc)
  end
end

