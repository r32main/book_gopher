class BooksController < ApplicationController
  def index
    if params[:order].in? %w[asc desc]
      @pagy, @books = pagy Book.order(id: params[:order])
    else
      @pagy, @books = pagy Book.order(id: 'desc')
    end
    @pagy, @books = pagy Book.order(name: params[:order_name]) if params[:order_name].in? %w[asc desc]
    @pagy, @books = pagy Book.order(price: params[:order_price]) if params[:order_price].in? %w[asc desc]
    @pagy, @books = pagy Book.order(availability: params[:order_av]) if params[:order_av].in? %w[asc desc]
  end
end

