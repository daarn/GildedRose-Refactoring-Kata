require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  FOO_ITEM = [Item.new("foo", 0, 0)]
  SULFURAS = [Item.new("Sulfuras, Hand of Ragnaros", 10, 80)]
  BACKSTAGE_PASSES = [ 
    Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
    Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=20),
    Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=20)
  ]
  CONJURED = [Item.new("Conjured Sword", 10, 10)]

  def test_can_create_valid_item
    items = FOO_ITEM
    assert_equal items[0].name, "foo"
    assert_equal items[0].sell_in, 0
    assert_equal items[0].quality, 0
  end

  def test_can_update_quality
    items = FOO_ITEM
    assert GildedRose.new(items).update_quality()
  end

  def test_can_to_s
    items = FOO_ITEM
    assert_equal "foo, 0, 0", items[0].to_s
  end

  def test_normal_item_update
    items = [Item.new("Sword", 10, 20)]
    shop = GildedRose.new(items)

    for i in 1..10 do
      shop.update_quality()
      assert_equal items[0].sell_in, 10-i
      assert_equal items[0].quality, 20-i
    end
  end

  def test_brie_update
    items = [Item.new("Aged Brie", 10, 10)]
    shop = GildedRose.new(items)

    for i in 1..10 do
      shop.update_quality()
      assert_equal items[0].sell_in, 10-i
      assert_equal items[0].quality, 10+i
    end
  end

  def test_sulfuras_update
    items = SULFURAS
    GildedRose.new(items).update_quality()

    assert_equal items[0].sell_in, 10
    assert_equal items[0].quality, 80
  end

  def test_backstage_passes_update
    items = BACKSTAGE_PASSES
    GildedRose.new(items).update_quality()

    assert_equal items[0].sell_in, 14
    assert_equal items[1].sell_in, 9
    assert_equal items[2].sell_in, 4

    assert_equal items[0].quality, 21
    assert_equal items[1].quality, 22
    assert_equal items[2].quality, 23
  end

  def test_conjured_update
    items = CONJURED
    GildedRose.new(items).update_quality()

    assert_equal items[0].sell_in, 9
    assert_equal items[0].quality, 8
  end

  def test_quality_min
    items = FOO_ITEM
    GildedRose.new(items).update_quality()
    assert items[0].quality == 0
  end

  def test_brie_quality_max
    items = [Item.new("Aged Brie", 10, 50)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 50

    items = [Item.new("Aged Brie", 0, 50)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 50
  end

  def test_backstage_passes_quality_max
    items = [ 
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=49),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49)
    ]
    GildedRose.new(items).update_quality()

    assert_equal items[0].quality, 50
    assert_equal items[1].quality, 50
    assert_equal items[2].quality, 50
  end

  def test_backstage_passes_after_concert
    items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=49)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 0
  end

  def test_quality_past_sell
    items = [Item.new("Sword", 0, 20)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 18

    items = [Item.new("Conjured Sword", 0, 20)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].quality, 16
  end

end