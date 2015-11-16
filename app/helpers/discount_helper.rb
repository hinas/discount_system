module DiscountHelper
  Rules::rule_hash = HashWithIndifferentAccess.new
  def add_rule(key,rule)
    Rules::rule_hash[key] = rule
  end 

  def validate_rules(bill,discount)
    result = true
    Rules::rule_hash.each { |key,a| result = result && eval(a)}
    return result
  end

  def initialize_discount_rules
    Rules::rule_hash.merge!(:min_amount_required => "bill.amount >= discount.min_order")
    Rules::rule_hash.merge!(:category_applicable => "discount.applicable_categories.present? ? (discount.applicable_categories.include? bill.category_id) : false")
    Rules::rule_hash.merge!(:mode_applicable => "discount.applicable_modes.present? ? (discount.applicable_modes.include? bill.mode_of_payment) : false")
    Rules::rule_hash.merge!(:not_begin => "discount.begin_date.nil? ? true : (bill.order_time - discount.begin_date >= 0)")
    Rules::rule_hash.merge!(:expired => "discount.end_date.nil? ? true : (bill.order_time - discount.end_date <= 0)")
  end

  def del_rule(key)
    Rules::rule_hash.delete(key)
  end

   # on service completion, we can apply dicount on the bill
  def apply_discount
    initialize_discount_rules
    bill = Bill.new(1,110,Time.now(),'NEWUSER',1, 1)
    bill.amount = get_discounted_value(bill)
    ## some other code
  end

  def validate_discount bill
    discount = Discount.find_by(:discount_code => bill.discount_code)
    if discount.present?
      return validate_rules(bill,discount) ? discount : nil
    else
      return nil
    end
  end

  ## on service completion, process discount
  def get_discounted_value bill
    #  this function needs to be called only once to initialize rules
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