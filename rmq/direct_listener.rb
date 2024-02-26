require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.direct('direct_logs')
queue = channel.queue('', exclusive: true)

%w[info warn error].each do |severity|
  queue.bind(exchange, routing_key: severity)
end

puts ' [*] Waiting for logs. To exit press CTRL+C'

begin
  queue.subscribe(block: true) do |delivery_info, _properties, body|
    puts " [x] #{delivery_info.routing_key}:#{body}"
  end
rescue Interrupt => _
  channel.close
  connection.close

  exit(0)
end