class TransactionItem
  attr_reader :date, :amount, :memo, :code

  def initialize(date, amount, code, memo)
    @date = date
    @amount = amount
    @code = code
    @memo = memo
  end

  

end
