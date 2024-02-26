require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('task_queue', durable: true)

begin
  puts ' [*] Waiting for messages. To exit press CTRL+C'
  queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
    puts " [x] Received: '#{body.chomp}'"
    sleep rand(1..3)
    puts ' [x] Done'
    channel.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  connection.close

  exit(0)
end