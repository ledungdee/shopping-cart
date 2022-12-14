# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def index
    @cart_items = current_cart_session.cart_items
    # cart_items_collapse(@cart_items)
    # # binding.pry
    $ship = 2
    $ship = 0 if current_cart_session.sum_money >= 200 || current_cart_session.cart_items.blank?
    @item_number = 0
    @cart_items.each do |t|
      @item_number += t.quantity
    end
  end

  def cart_items_collapse(cart_items)
    (0...cart_items.count).each do |i|
      quantity = cart_items[i].quantity
      ((i + 1)...cart_items.count).each do |j|
        next unless cart_items[i].product_id == cart_items[j].product_id && cart_items[i].size == cart_items[j].size

        @a = cart_items[j].quantity
        @a += quantity
        cart_items[i].destroy
        cart_items[j].update_attribute(:quantity, @a)
        break
      end
    end
  end

  def create
    a = max_quantity($id_current_product, params[:size])
    if params[:quantity].to_i.positive? && params[:quantity].to_i <= a
      @cart_item = CartItem.new
      @cart_item.cart_session_id = current_user.cart_session.id
      @cart_item.quantity = params[:quantity]
      @cart_item.size = params[:size]
      @cart_item.product_id = current_product.id
      @cart_item.price = @cart_item.product.price
      sum_money = @cart_item.cart_session.sum_money
      sum_money += @cart_item.product.price * @cart_item.quantity
      @cart_item.cart_session.update_attribute(:sum_money, sum_money)
      if @cart_item.save
        flash[:success] = 'Success added to cart'
        redirect_to current_product
      else
        render 'new', status: :unprocessable_entity
      end
    else
      redirect_to current_product
      flash[:danger] = 'Product is not enough'
    end
  end

  def destroy
    @destroy_item = CartItem.find_by(id: params[:id])
    sum_money = current_cart_session.sum_money
    sum_money -= @destroy_item.product.price * @destroy_item.quantity
    current_cart_session.update_attribute(:sum_money, sum_money)
    @destroy_item.destroy
    flash[:success] = 'Deleted this item'
    redirect_to cart_items_path, status: :see_other
  end

  def update_quantity
    @id = params[:cart_item][:id_product].to_i
    @size = params[:cart_item][:size]
    @a = max_quantity(@id, @size)
    # binding.pry
    if params[:quantity].to_i <= @a
      @cart_item = CartItem.find_by(id: params[:cart_item][:id_item_update])
      sum_money = @cart_item.cart_session.sum_money
      now_quantity = @cart_item.quantity.to_i
      new_quantity = params[:quantity].to_i

      if new_quantity > now_quantity
        sum_money += (new_quantity - now_quantity) * @cart_item.product.price
      else
        sum_money -= (now_quantity - new_quantity) * @cart_item.product.price
      end
      @cart_item.cart_session.update_attribute(:sum_money, sum_money)
      @cart_item.update_attribute(:quantity, new_quantity)
      @cart_item.destroy if new_quantity.zero?
      redirect_to cart_items_path
      # binding.pry
    else
      redirect_to cart_items_path
      flash[:danger] = 'Product is not enough'
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:cart_session_id, :product_id, :quantity)
  end

  def logged_in_user
    return unless logged_in? == false

    store_location # L10.32
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
  end

  def max_quantity(id, size)
    @product = Product.find_by(id:)
    case size
    when 'S' then @product.size_s
    when 'M' then @product.size_m
    when 'L' then @product.size_l
    else
      @product.size_xl
    end
  end
end
