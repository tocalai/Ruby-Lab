require './account.rb'
require './transaction.rb'

include OperationResult
include OperationCode

test_account = Account.new('TestAccount1', 100_100)
desposit_trans = TransactionItem.new(Time.new, 10, DESPOSIT, 'Desposit by Alice')
test_account.desposit(desposit_trans)

withdraw_trans_over_balance = TransactionItem.new(Time.new, 100_101, WITHDRAW, 'Withdraw by Bob')
#test_account.withdraw(withdraw_trans_over_balance)

withdraw_trans = TransactionItem.new(Time.new, 100, WITHDRAW, 'Withdraw by Tom')
test_account.withdraw(withdraw_trans)

test_account.show_history(5)

