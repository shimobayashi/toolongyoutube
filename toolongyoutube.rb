# frozen_string_literal: true

input = $stdin.read

pairs = input.scan(/((?:.*(?:\n|$)){2})/)

messages = []
pairs.each do |pair|
  timestamp, body = pair[0].split.map(&:chomp)
  next unless timestamp && body

  match_data = timestamp.match(/((\d{1,2}):)?(\d{2}):(\d{2})/)
  next unless match_data

  _, hour, minute, second = match_data.captures
  messages << {
    hour: hour,
    minute: minute,
    second: second,
    body: body
  }
end

pp messages
