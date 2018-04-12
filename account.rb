require './enums.rb'
require './transaction.rb'
require 'thread'

class Account
   include OperationResult

   def initialize(name, balance = 0)
    @name = name
    @balance = balance
    @trans_history = []
    @mutex = Mutex.new
  end
  
  public
  def get_balance
    @balance
  end
  
  def desposit(trans)
    @mutex.synchronize do
      if trans.amount <= 0
        puts "Input amount '#{trans.amount}' invalid"
        return INVALIDINPUT
      end

      @balance += trans.amount    
      puts "Account: #{@name}, desposit: #{trans.amount}, balance: #{@balance}"
      # add to history
      @trans_history.push(trans)
      SUCCEEDED  
    end 
    
  end

  def withdraw(trans)
    @mutex.synchronize do
      if @balance >= trans.amount
          @balance -= trans.amount
          puts "Account: #{@name}, withdraw: #{trans.amount}, balance: #{@balance}"
          # add to history
          @trans_history.push(trans)
          return SUCCEEDED
      end

      puts "Account: #{@name}, withdraw failed: #{trans.amount}, balance: #{@balance} not enough"
      FAILED
    end
  end

  def show_balance_info
    puts "Account:#{@name}, balance: #{@balance}"
    return SUCCEEDED
  end

  def show_history(count)
    if !(count.is_a? Integer) || count < 1 
       puts "Input '#{count}' invalid"
       return INVALIDINPUT
    end

    if !@trans_history.any?
      puts 'History was empty'    
      return HISTORYEMPTY
    end

    puts 'History:'
    puts '-----------------------------------------'
    @trans_history[0..count - 1].each_with_index do
        |t, i| puts "[#{i + 1}] Date: #{t.date}, amount: #{t.amount}, op-code: #{t.code}, memo: #{t.memo}"
      
    end
    puts '-----------------------------------------'
    return SUCCEEDED
  end

end
