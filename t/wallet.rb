require 'test/unit'
require './wallet.rb'

class TestWallet < Test::Unit::TestCase
    def setup
        @obj = Wallet.new
    end
    def test_new
        assert_instance_of(Wallet, @obj)
    end
    def test_amount
        assert_equal(0, @obj.amount)
    end
    def test_deposit
        assert_equal(0, @obj.amount)
        @obj.deposit(5)
        assert_equal(5, @obj.amount)
    end
    def test_withdraw
        @obj.deposit(5)
        assert_equal(5, @obj.amount)
        @obj.withdraw(3)
        assert_equal(2, @obj.amount)
    end
    def test_withdraw_should_raise_error_when_we_withdraw_over_amount
        @obj.deposit(5)
        assert_equal(5, @obj.amount)
        assert_raise(Wallet::OverAmountWithdrawException){
            @obj.withdraw(100)
        }
        assert_equal(5, @obj.amount)
    end
end
