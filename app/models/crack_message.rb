require_relative 'message.rb'
require_relative 'cryption_module'
require_relative 'offset_gen'
require_relative 'message_io'

class CrackMessage
  include Cryption, MessageIO, OffsetGen
  attr_reader :to_crack

  def initialize(message, date=Date.today)
    @to_crack = Message.new(message, nil, date)
  end

  def crack
    decrypt
    key_from_date
    "Message cracked with key: #{@to_crack.key} and date: #{@to_crack.date.to_s}"
  end

  def decrypt
    parse_and_split_message
    find_rotations
    rotation = @to_crack.rotation.map{ |num| num * -1 }
    @to_crack.message = run_the_cipher(@to_crack.message, rotation)
  end

  def key_from_date
    offset = convert_into_offset(@to_crack.date)
    split_key = @to_crack.rotation.zip(offset).map! do |roto_offset|
      keep_key_value_positive(roto_offset)
    end
    include_leading_zeros(split_key)
    @to_crack.key = regenerate(split_key.join.split(''))
  end

  def find_rotations
    a = find_character_indexes
    b = comparison_index
    rotation = a.zip(b).map! do |index|
      (index[0]) - index[1]
    end
    @to_crack.rotation = positive_rotations(rotation)
  end

  private

  def parse_and_split_message
    message = parse(@to_crack.message)
    @to_crack.message = split_into_sub_arrays(message)
  end

  def last_group_of_four
    @to_crack.message.reverse.find{|sub_array|sub_array.length == 4}
  end

  def comparison_index
    COMPARISON_INDEX[@to_crack.message[-1].length]
  end

  def find_character_indexes
    last_group_of_four.map do |character|
      CIPHER.index(character)
    end
  end

  def include_leading_zeros(split_key)
    split_key.map! do |number|
      ensure_zero(number)
    end
  end
  
  def positive_rotations(rotation)
    rotation.map! do |number|
      make_rotation_positive(number)
    end
  end

  def regenerate(num)
    (num[0] + num[1] + num[3] + num[5] + num[7])    
  end

  def ensure_zero(number)
    if number > 10
      number.to_s
    else
      "0" + number.to_s
    end
  end

  def keep_key_value_positive(sub)
    if sub[0] < 10
      (sub[0] + CIPHER.length) - sub[1]
    else
      (sub[0] - sub[1])
    end
  end

  def make_rotation_positive(number)
    if number < 0 
      number + CIPHER.length 
    else
      number
    end
  end
end