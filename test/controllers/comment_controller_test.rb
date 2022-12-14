# frozen_string_literal: true

require 'test_helper'

class CommentControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get comment_new_url
    assert_response :success
  end

  test 'should get edit' do
    get comment_edit_url
    assert_response :success
  end

  test 'should get destroy' do
    get comment_destroy_url
    assert_response :success
  end

  test 'should get update' do
    get comment_update_url
    assert_response :success
  end

  test 'should get show' do
    get comment_show_url
    assert_response :success
  end
end
