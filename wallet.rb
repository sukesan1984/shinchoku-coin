class Wallet
    attr_accessor :amount
    def initialize
        @amount = 0
    end
    def deposit(addition)
        @amount += addition
    end
    def withdraw(substraction)
        temp = @amount - substraction
        if temp < 0 then
            raise OverAmountWithdrawException
        end
        @amount -= substraction
    end
    class OverAmountWithdrawException < Exception
    end
end

