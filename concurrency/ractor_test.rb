a = Ractor.new do
  loop do
    Ractor.yield true

    message = Ractor.receive
    sleep(3)

    Ractor.yield message + Ractor.current.to_s
  end
end

b = Ractor.new(a) do |ab|
  ready, obj = Ractor.select(ab)
  puts ready
  ready.send('hui')
  ready.take
end

puts b.take