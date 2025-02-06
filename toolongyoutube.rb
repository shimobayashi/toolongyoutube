# frozen_string_literal: true

# Input & Parse

vid = ARGV[0]
input = File.read("#{vid}.txt")
pairs = input.scan(/((?:.*(?:\n|$)){2})/)

messages = []
pairs.each do |pair|
  timestamp, body = pair[0].split.map(&:chomp)
  next unless timestamp && body

  match_data = timestamp.match(/((\d{1,2}):)?(\d{1,2}):(\d{2})/)
  next unless match_data

  _, hour, minute, second = match_data.captures
  messages << {
    hour: hour.to_i || 0,
    minute: minute.to_i,
    second: second.to_i,
    body: body
  }
end

chunks = []
current_chunk = []
messages.each do |message|
  current_chunk << message

  # 自分が試した限りでは2000文字より多くするとアウトプットの品質が如実に下がっていった
  if current_chunk.map { |m| m[:body] }.join.length > 2000 || message == messages.last
    chunks << current_chunk
    current_chunk = []
  end
end

# Output for Cosense

puts '#toolongyoutube'
puts

chunks.each do |chunk|
  fm = chunk.first
  time = fm[:hour] * 360 + fm[:minute] * 60 + fm[:second]
  puts "[https://www.youtube.com/watch?v=#{vid}&t=#{time}]"

  puts 'code: 清書'
  puts "\t"
  puts 'code: raw'
  puts "\t#{chunk.map { |m| m[:body] }.join(' / ')}"
  puts
end
