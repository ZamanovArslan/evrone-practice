require 'uri'
require 'net/http'
require 'byebug'

def send_request
  uri = URI('https://google.com')
  res = Net::HTTP.get_response(uri)
  res.body
end

consumers = 5.times.map do
  Ractor.new do
    loop do
      Ractor.yield true
      puts 'ready to listen'
      id = Ractor.receive
      puts "Doing smth with: #{id}"
    end
  end
end

queue = Ractor.new(consumers) do |consumers|
  jobs_ids = Queue.new

  jobs_listener = Thread.new do
    loop do
      id = Ractor.receive
      puts "listener received: #{id}"
      jobs_ids << id
    end
  end

  jobs_sender = Thread.new do
    loop do
      ready_ractor = Ractor.select(*consumers).first

      while jobs_ids.empty?
        puts 'sender sleeps'
        sleep(1)
      end

      puts "start sending to: #{ready_ractor}"
      ready_ractor.send(jobs_ids.pop)
      puts 'message sent'
    end
  end

  jobs_listener.join
  jobs_sender.join
end


while (input = gets.chomp) != 'stop'
  puts "sending to queue: #{input.to_i}"
  queue.send(input.to_i)
end
