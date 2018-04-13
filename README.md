# Ruby-Lab

- Build the Ruby development environment via **Visual studio code** with extension [Ruby](https://github.com/rubyide/vscode-ruby)
- For the **BDD** (Behaviour Drive Development) purpose, download and installed [RSpec](http://rspec.info/)

1. First we created empty class called: *Account* inside the account.rb
```sh
class Account
end
```
2. Then we created our first test scenario inside the account_spec.rb
> The testing target aim for *Account* class
```sh
RSpec.describe Account do
end
```
3. We need initilize our account object under the *constructor*
> So before we startup our testing case, we need create new account object that passing account identity and balance while account first open
```sh
RSpec.describe Account do
  before(:all) do
          @inital_balance = 100_100
          @test_account = Account.new('TestAccount1', @inital_balance)
   end
end
```
4. Let's run the test case and you  might get red light(or failed) 
> Cause we did not implement constructor inside the account.rb yet
```sh
class Account
   def initialize(name, balance = 0)
    @name = name
    @balance = balance
  end
end
```
5. Now turned back to account_spec.rb and performed the testing, we might get rid of error, means that we got green light
> For the next step, started to write the first feature of test case, for exmaple: *desposit*
```sh
RSpec.describe Account do
  before(:all) do
          @inital_balance = 100_100
          @test_account = Account.new('TestAccount1', @inital_balance)
   end
   describe ".desposit" do
       context 'When transaction amount <= 0' do
            it 'Should return intput amount [x] invalid' do
                @trans =  TransactionItem.new(Time.new, -1, DESPOSIT, 'Desposit invalid test')
                @result = @test_account.desposit(@trans)
                expect(@result).to eq INVALIDINPUT
            end
        end
   end
end
```
6. Again triggered the test case, red light return
> Go back to account.rb and implement the detail of desposit method and created the new class *TranasctionItem*...
```sh
class Account
  #....
  def desposit(trans)
      if trans.amount <= 0
        puts "Input amount '#{trans.amount}' invalid"
        return INVALIDINPUT
      end
  end
end

class TransactionItem
  attr_reader :date, :amount, :memo, :code

  def initialize(date, amount, code, memo)
    @date = date
    @amount = amount
    @code = code
    @memo = memo
  end
end
```
7. Tried to finish the test case and let it become green light, iterator the process till the user requriement all meet:) 
> Test case -> red light -> implment detail -> green light -> back to test case

* Exmaple of test case that simulate concurrent environment
![Multi-threading](https://github.com/tocalai/Ruby-Lab/blob/master/image/transaction_concurrent.png)
