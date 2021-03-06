class Customer::ShippingAddressesController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_current_customer, only: [:edit, :update, :destroy]

  def index
    customer = Customer.find(current_customer.id)
    @shipping_addresses = customer.shipping_addresses
    @shipping_address = ShippingAddress.new
  end

  def create
    @shipping_address = ShippingAddress.new(shipping_address_params)
    @shipping_address.customer_id = current_customer.id
    if @shipping_address.save
      flash[:success] = "配送先を追加登録しました。"
      redirect_to request.referer
    else
      @shipping_addresses = current_customer.shipping_addresses
      flash.now[:danger] = "全ての項目を正しく入力してください。"
      render :index
    end
  end

  def destroy
    @shipping_address = ShippingAddress.find(params[:id])
    @shipping_address.destroy
    flash[:notice] = '配送先を削除しました。'
    redirect_to request.referer
  end

  def edit
    @shipping_address = ShippingAddress.find(params[:id])
    if @shipping_address.customer == current_customer
      render :edit
    else
      redirect_to shipping_addresses_path(@shipping_address.id)
    end
  end

  def update
    @shipping_address = ShippingAddress.find(params[:id])
    if @shipping_address.update(shipping_address_params)
      flash[:success] = "配送先を更新しました。"
      redirect_to shipping_addresses_path
    else
      flash.now[:danger] = "全ての項目を正しく入力してください。"
      render :edit
    end
  end

  private
  def shipping_address_params
    params.require(:shipping_address).permit(:name, :postal_code, :address)
  end

  def ensure_current_customer
    @shipping_address = ShippingAddress.find(params[:id])
    unless @shipping_address.customer == current_customer
      redirect_to shipping_addresses_path
    end
  end
end
