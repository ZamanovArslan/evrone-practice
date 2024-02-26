require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

queue = channel.queue('task_queue', durable: true)
fan_exchange = channel.fanout('logs')
warn_exchange = channel.direct('direct_logs')

begin
  while (input = gets.chomp) != 'exit'
    if input.start_with?('log')
      fan_exchange.publish(input, persistent: true)
      puts " [x] Sent to fanout exchange: '#{input}'"
    elsif input.start_with?('warn')
      warn_exchange.publish(input, routing_key: 'warn', persistent: true)
      puts " [x] Sent to direct exchange: '#{input}'"
    else
      channel.default_exchange.publish(input, routing_key: queue.name, persistent: true)
      puts " [x] Sent: '#{input}'"
    end
  end
rescue Interrupt => _
  connection.close

  exit(0)
end

connection.close

