class Customer::ProductsController < ApplicationController
   before_action :authenticate_customer!, except: [:show, :index]
  def index
    @products = Product.page(params[:page]).per(8).reverse_order
    @genres = Genre.all
  end

  def show
    @product = Product.find(params[:id])
    @cart_product = CartProduct.new
    @genres = Genre.all
  end
end