class Part1
  def self.is_invalid?(id)
    l = id.length / 2
    id[...l] == id[l..]
  end
end

class Part2
  def self.is_invalid?(id)
    l = id.length / 2
    (1..l).each do |i|
      return true if (id.scan(/.{1,#{i}}/).uniq.size == 1)
    end
    false
  end
end

class Main
  class << self
    def get_result(ranges, validator)
      result = 0

      ranges.each do |a, z|
        a.to_i.upto (z.to_i+1) do |n|
          result += n if validator.is_invalid? n.to_s
        end
      end

      result
    end

    def main
      contents = File.read './example.txt'

      ranges = contents.strip.split(',').map{_1.split('-')}

      part1_result = get_result ranges, Part1
      puts "Part 1: #{part1_result}"

      part2_result = get_result ranges, Part2
      puts "Part 2: #{part2_result}"
    end

  end
end

if __FILE__ == $0 then
  Main.main
end
