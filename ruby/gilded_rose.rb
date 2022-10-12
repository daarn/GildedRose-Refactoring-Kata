class GildedRose
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BRIE = "Aged Brie"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"

  MAX_QUALITY = 50

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == SULFURAS
      
      item.sell_in -= 1
      
      quality_decrement = conjured?(item) ? 2 : 1

      case item.name
      when BRIE
        update_brie(item)
      when BACKSTAGE_PASS
        update_backstage_pass(item)
      else
        update_standard_item(item, quality_decrement)
      end
    end
  end

  def update_brie(item)
    return if item.quality == MAX_QUALITY

    item.quality += 1
  end

  def update_backstage_pass(item)
    return item.quality = 0 if past_sell_date?(item)
    return if item.quality == MAX_QUALITY

    if item.sell_in <= 5
      item.quality += 3
    elsif item.sell_in <= 10
      item.quality += 2
    else
      item.quality += 1
    end

    max_quality?(item)
  end

  def update_standard_item(item, quality_decrement)
    return if item.quality == 0
    
    item.quality -= quality_decrement
    item.quality -= quality_decrement if past_sell_date?(item)

    item.quality = 0 if item.quality.negative?
  end

  def conjured?(item)
    item.name.start_with?("Conjured")
  end

  def max_quality?(item)
    item.quality = MAX_QUALITY if item.quality >= MAX_QUALITY
  end

  def past_sell_date?(item)
    item.sell_in.negative?
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
