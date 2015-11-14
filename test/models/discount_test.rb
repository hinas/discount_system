require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  def setup
  	#new user and discount is valid
    @bill1 = Bill.new(1,110, '2015-11-14 00:36:55 +0530', 'ANYOTHER' ,'COD', 'electrician')
    #discount expired
    @bill2 = Bill.new(1,110, '2015-11-14 00:36:55 +0530', 'ANYOTHER' ,'COD', 'electrician')
    #dicount not applicable on particular category
    @bill3 = Bill.new(1,110, '2015-11-14 00:36:55 +0530', 'ANYOTHER' ,'COD', 'electrician')
    #bill amount is less than the minimum value
    @bill4 = Bill.new(1,110, '2015-11-14 00:36:55 +0530', 'ANYOTHER' ,'COD', 'electrician')
    #bill is not applicable on that mode of payment
    @bill5 = Bill.new(1,110, '2015-11-14 00:36:55 +0530', 'ANYOTHER' ,'COD', 'electrician')
    #discount coupon is not valid
    @bill6 = Bill.new(1,110, '2015-11-14 00:36:55 +0530', 'ANYOTHER' ,'COD', 'electrician')
  end
  test "should_apply_discount" do
  	discount_actual = Discount.find_by(:discount_code => @bill1.discount_code)
  	discount = apply_discount(@bill1)
  	assert_nil discount, discount_actual , "discount applied is not correct"
  	discount = apply_discount(@bill2)
  	assert_nil discount
  	discount = apply_discount(@bill3)
  	assert_nil discount
    discount = apply_discount(@bill4)
  	assert_nil discount 
  	discount = apply_discount(@bill5)
  	assert_nil discount
  	discount = apply_discount(@bill5)
  	assert_nil discount
  end
end
