# frozen_string_literal: true

input = $stdin.read

pairs = input.scan(/((?:.*(?:\n|$)){2})/)

messages = []
pairs.each do |pair|
  timestamp, body = pair[0].split.map(&:chomp)
  next unless timestamp && body

  match_data = timestamp.match(/((\d{1,2}):)?(\d{1,2}):(\d{2})/)
  next unless match_data

  _, hour, minute, second = match_data.captures
  messages << {
    hour: hour,
    minute: minute,
    second: second,
    body: body
  }
end

# pp messages

chunks = []
current_chunk = []
messages.each do |message|
  current_chunk << message

  if current_chunk.map { |m| m[:body] }.join.length > 2000 || message == messages.last
    chunks << current_chunk
    current_chunk = []
  end
end

chunks.each do |chunk|
  puts chunk.first
  puts chunk.last
  puts chunk.map { |m| m[:body] }.join(' / ')
end
