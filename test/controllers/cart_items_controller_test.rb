# frozen_string_literal: true

require 'test_helper'

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get cart_items_index_url
    assert_response :success
  end

  test 'should get show' do
    get cart_items_show_url
    assert_response :success
  end

  test 'should get new' do
    get cart_items_new_url
    assert_response :success
  end

  test 'should get edit' do
    get cart_items_edit_url
    assert_response :success
  end

  test 'should get create' do
    get cart_items_create_url
    assert_response :success
  end

  test 'should get update' do
    get cart_items_update_url
    assert_response :success
  end

  test 'should get destroy' do
    get cart_items_destroy_url
    assert_response :success
  end

  test 'should get update_quantity' do
    get cart_items_update_quantity_url
    assert_response :success
  end
end
