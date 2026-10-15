require "test_helper"

class DogTest < ActiveSupport::TestCase
  test "名前が空欄の場合は保存できない" do
    dog = Dog.new(name: "", breed: "チワワ", personality: "元気")

    assert_not dog.valid?
    assert_includes dog.errors[:name], "can't be blank"
  end

  test "犬種が空欄の場合は保存できない" do
    dog = Dog.new(name: "ココ", breed: "", personality: "元気")

    assert_not dog.valid?
    assert_includes dog.errors[:breed], "can't be blank"
  end

  test "性格が空欄の場合は保存できない" do
    dog = Dog.new(name: "ココ", breed: "チワワ", personality: "")

    assert_not dog.valid?
    assert_includes dog.errors[:personality], "can't be blank"
  end
end