require 'test_helper'
include DiscountHelper

class DiscountHelperTest < ActiveSupport::TestCase
  def setup
  	#new user and discount is valid
    @bill1 = Bill.new(1,110, Time.now , 'NEWUSER' ,1, 1)
    #discount expired
    @bill2 = Bill.new(1,110, Time.now - 1.day, 'NEWUSER' ,1, 1)
    #dicount not applicable on particular category
    @bill3 = Bill.new(1,110, Time.now, 'FB200' ,1, 4)
    #bill amount is less than the minimum value
    @bill4 = Bill.new(1,10, Time.now, 'MORE100' ,1, 1)
    #bill is not applicable on that mode of payment
    @bill5 = Bill.new(1,110, Time.now, 'ANYOTHER' ,2, 1)
    #discount coupon is not valid
    @bill6 = Bill.new(1,110, Time.now, 'ANY' ,1, 1)
    #no discount code applied
    @bill7 = Bill.new(1,110, Time.now, nil ,1, 1)
    #discount applied is more than the bill amount
    @bill8 = Bill.new(1,110, Time.now, 'ANYOTHER' ,1, 1)
  end

  test "should_apply_discount" do
  	discount = get_discounted_value(@bill1)
  	assert_equal discount, 10 , "bill amount should be 10"
  	discount = get_discounted_value(@bill2)
  	assert_equal discount, 110, "bill amount should be 110"
  	discount = get_discounted_value(@bill3)
  	assert_equal discount, 110, "bill amount should be 110"
    discount = get_discounted_value(@bill4)
  	assert_equal discount, 10, "bill amount should be 10"
  	discount = get_discounted_value(@bill5)
  	assert_equal discount, 110, "bill amount should be 110"
  	discount = get_discounted_value(@bill6)
  	assert_equal discount, 110, "bill amount should be 110"
    discount = get_discounted_value(@bill7)
    assert_equal discount, 110, "bill amount should be 110"
    discount = get_discounted_value(@bill8)
    assert_equal discount, 0 , "bill amount should be 0"
  end
end
