require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

fan_exchange = channel.fanout('logs')
fanout_queue = channel.queue('', exclusive: true)

fanout_queue.bind(fan_exchange, routing_key: 'logs.critical')

begin
  puts ' [*] Waiting for messages. To exit press CTRL+C'
  fanout_queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] From fanout queue: #{body}"
  end
rescue Interrupt => _
  connection.close

  exit(0)
end