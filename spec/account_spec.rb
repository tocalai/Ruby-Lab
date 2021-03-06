require './account.rb'
require './transaction.rb'
require 'thread'

include OperationResult
include OperationCode

RSpec.describe Account do
    before(:all) do
          @inital_balance = 100_100
          @test_account = Account.new('TestAccount1', @inital_balance)
          @deposit_amount = 10
          @withdraw_amount = 100
          @history_count = 5
    end
    describe ".deposit" do        
        context 'When transaction amount > 0' do
            it 'Should return balance = balance + amount' do
                @trans = TransactionItem.new(Time.new, @deposit_amount, DEPOSIT, 'Deposit test')
                @test_account.deposit(@trans)               
                @expected = @inital_balance + @deposit_amount 
                expect(@test_account.get_balance).to eq @expected
            end
        end
        
        context 'When transaction amount <= 0' do
            it 'Should return intput amount [x] invalid' do
                @trans =  TransactionItem.new(Time.new, -1, DEPOSIT, 'Deposit invalid test')
                @result = @test_account.deposit(@trans)
                expect(@result).to eq INVALIDINPUT
            end
        end
    end

    describe '.withdraw' do
        context 'When transaction amount > balance' do
            it 'Should return failed and propmt user that balance not enough' do
                @trans =  TransactionItem.new(Time.new, @test_account.get_balance + 100, WITHDRAW, 'withdraw invalid test')
                @result = @test_account.withdraw(@trans)
                expect(@result).to eq FAILED
            end
        end

         context 'When transaction amount <= balance' do
            it 'Should return balance = balance - amount' do
                @trans =  TransactionItem.new(Time.new, @withdraw_amount, WITHDRAW, 'withdraw test')
                @result = @test_account.withdraw(@trans)             
                @expected = @inital_balance + @deposit_amount -  @withdraw_amount
                expect(@test_account.get_balance).to eq @expected
            end
        end
    end

    describe '.show_history' do
        context "When show the #{@history_count} records" do
            it 'Should return succeed and print out the transaction history' do
               @result = @test_account.show_history(@history_count)
               expect(@result).to eq SUCCEEDED 
            end            
        end

        context 'When without history infos' do
            it 'Should return history empty code' do
                @test_account = Account.new('TestAccount2', @inital_balance)
                @result = @test_account.show_history(@history_count)
                expect(@result).to eq HISTORYEMPTY 
            end
        end
    end

    describe '.deposit, .witdraw' do
        context 'Perform deposit and withdraw under multi-thread' do
            it 'Should return correct balance under the condition' do
                @test_account = Account.new('TestAccount2', @inital_balance)
                @concurrent_threads = 3
                @repeat_count = 100
                @threads_deposit = []
                @threads_withdraw = []
                for i in 1..@concurrent_threads do
                    @t_deposit = Thread.new {
                       for j in 1..@repeat_count do
                          @trans_deposit = TransactionItem.new(Time.new, @deposit_amount, DEPOSIT, 'Deposit test')
                          @test_account.deposit(@trans_deposit)
                       end
                    }

                    @threads_deposit.push(@t_deposit)

                    @t_withdraw = Thread.new {
                       @trans_withdraw =  TransactionItem.new(Time.new, @withdraw_amount, WITHDRAW, 'withdraw test')
                       @test_account.withdraw(@trans_withdraw)
                    }
                    
                    @threads_withdraw.push(@t_withdraw)
                end
                 @threads_deposit.each {|t| t.join}
                 @threads_withdraw.each {|t| t.join}

                 @expected = @inital_balance + @concurrent_threads * @repeat_count * @deposit_amount - @concurrent_threads * @withdraw_amount
                 expect(@test_account.get_balance).to eq @expected
            end
        end
    end
end