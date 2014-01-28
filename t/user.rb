require 'test/unit'
require './user.rb'

class TestUser < Test::Unit::TestCase
    def setup
        @obj1 = User.new(1, "takami")
        @obj2 = User.new(2, "okihara")
    end
    def test_new
        assert_instance_of(User, @obj1)
    end
    def test_name1
        assert_equal("takami", @obj1.name)
    end
    def test_name2
        assert_equal("okihara", @obj2.name)
    end
    def test_id1
        assert_equal(1, @obj1.id)
    end
    def test_id_should_be_unique
        assert_not_equal(@obj1.id, @obj2.id)
    end
end
