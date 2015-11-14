module DiscountHelper
   # on service completion, we can apply dicount on the bill
  def apply_discount
    bill = Bill.new(1,110,Time.now(),'NEWUSER',1, 1)
    bill.amount = get_discounted_value(bill)
    ## some other code
  end

  def validate_discount bill
    discount = Discount.find_by(:discount_code => bill.discount_code)
    if discount.present?
      rule1 = bill.amount >= discount.min_order
      rule2 = discount.applicable_categories.present? ? (discount.applicable_categories.include? bill.category_id) : false
      rule3 = discount.applicable_modes.present? ? (discount.applicable_modes.include? bill.mode_of_payment) : false
      rule4 = discount.begin_date.nil? ? true : (bill.order_time - discount.begin_date >= 0)
      rule5 = discount.end_date.nil? ? true : (bill.order_time - discount.end_date <= 0)
      return (rule1 && rule2 && rule3 && rule4 && rule5) ? discount : nil
    else
      return nil
    end
  end

  ## on service completion, process discount
  def get_discounted_value bill
    return 0 if bill.nil?
    bill_amount = bill.amount
    if discount = validate_discount(bill)
      if discount.operation.eql? "x"
        bill_amount = bill_amount * (1 - discount.value * 0.01)
      elsif discount.operation.eql? "/"
        bill_amount = bill_amount - (bill_amount/discount.value).floor
      elsif discount.operation.eql? "-"
        bill_amount = bill_amount - discount.value
      end
    end
    return bill_amount < 0 ? 0 : bill_amount
  end
end