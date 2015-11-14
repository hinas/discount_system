class Bill
  attr_accessor :user_id, :amount, :order_time, :discount_code, :mode_of_payment, :category_id
  def initialize(user_id, amount, order_time, discount_code, mode_of_payment, category_id)
    @user_id = user_id
    @bill_amount = bill_amount
    @order_time = order_time
    @discount_code = discount_code
    @mode_of_payment = mode_of_payment
    @category = category
  end
end