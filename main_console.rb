require './account.rb'
require './transaction.rb'

include OperationResult
include OperationCode

test_account = Account.new('TestAccount1', 100_100)
deposit_trans = TransactionItem.new(Time.new, 10, DEPOSIT, 'Desposit by Alice')
test_account.deposit(deposit_trans)

withdraw_trans = TransactionItem.new(Time.new, 100, WITHDRAW, 'Withdraw by Tom')
test_account.withdraw(withdraw_trans)

test_account.show_history(5)

