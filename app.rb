require 'benchmark'
require 'uri'
require 'net/http'
require 'celluloid'
require "celluloid/autostart"
require "celluloid/pool"

REQUESTS_COUNT = 20

class SendRequestService
  include Celluloid

  def call
    uri = URI('https://google.com')
    res = Net::HTTP.get_response(uri)
    res.body
  end
end

def sync_requests
  REQUESTS_COUNT.times { send_request }
end

def send_request
  uri = URI('https://google.com')
  res = Net::HTTP.get_response(uri)
  res.body
end

def concurrent_requests
  threads = []
  requests_count = 0
  x = REQUESTS_COUNT

  10.times do
    threads << Thread.new do
      while x > 0
        send_request
        requests_count += 1
        x = x - 1
      end
    end
  end

  threads.map(&:join)
end

def safe_concurrent_requests
  threads = []
  requests_count = 0
  queue = Thread::Queue.new
  x = REQUESTS_COUNT
  x.times { queue.push(1) }

  10.times do
    threads << Thread.new do
      while queue.pop(true)
        send_request
        requests_count += 1
      end
    rescue ThreadError
    end
  end

  threads.map(&:join)
end

def celluloid_requests
  pool = SendRequestService.pool(size: 10)

  REQUESTS_COUNT.times { pool.async.call }
end

Benchmark.bm do |x|
  x.report('celluloid_requests') { celluloid_requests }
  x.report('safe_concurrent_requests') { safe_concurrent_requests }
  x.report('concurrent_requests') { concurrent_requests }
  x.report('sync_requests') { sync_requests }
end