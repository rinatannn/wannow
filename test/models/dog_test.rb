require "test_helper"

class DogTest < ActiveSupport::TestCase
  test "名前が空欄の場合は保存できない" do
    dog = Dog.new(name: "", breed: "チワワ", personality: "元気")

    assert_not dog.valid?
    assert_includes dog.errors[:name], "を入力してください"
  end

  test "犬種が空欄の場合は保存できない" do
    dog = Dog.new(name: "ココ", breed: "", personality: "元気")

    assert_not dog.valid?
    assert_includes dog.errors[:breed], "を入力してください"
  end

  test "性格が空欄の場合は保存できない" do
    dog = Dog.new(name: "ココ", breed: "チワワ", personality: "")

    assert_not dog.valid?
    assert_includes dog.errors[:personality], "を入力してください"
  end
end