#!/bin/env ruby

require 'curses'
require 'net/http'
require 'time'

include Curses

def inc_counter(counter, source, field)
  case source[field]
  when nil
    counter[:unknown] += 1
  else
    counter[source[field]] ||= 0
    counter[source[field]] += 1
  end
end


def worker(index, target, hosts, versions, logs)
  while true
    begin
      response = Net::HTTP.get_response(target)
      inc_counter hosts, response, 'X-Source'
      inc_counter versions, response, 'X-Version'
      logs[index] = [DateTime.now.strftime('%Q'), response['X-Source'],
                     response['X-Version']]
    rescue
      hosts[:failures] += 1
      versions[:failures] += 1
    end
  end
end

def stats(target, hosts, versions, num_workers, logs)
  init_screen
  crmode

  win_req = Window.new(21, 60, 1, 3)
  win_req.box(?|, ?-)

  win_ver = Window.new(12, 40, 1, 66)
  win_ver.box(?|, ?-)
  win_ver.setpos(2, 2)
  win_ver.addstr('Versions')

  win_log = Window.new(num_workers + 7, 60, 23, 3)
  win_log.box(?|, ?-)
  win_log.setpos(2, 2)
  win_log.addstr('Worker log')

  while true
    win_req.setpos(2, 2)
    win_req.addstr(Time.now.to_s)

    win_req.setpos(4, 2)
    win_req.addstr("Target: #{target}")

    win_req.setpos(2, 40)
    win_req.addstr("Workers : #{num_workers}")

    win_req.setpos(4, 40)
    win_req.addstr("Total   : #{hosts.values.reduce(:+)}")

    line = 7
    hosts.each do |name, count|
      win_req.setpos(line, 2)
      win_req.addstr('.' * 40)
      win_req.setpos(line, 2)
      win_req.addstr(name.to_s + ' ')
      win_req.setpos(line, 43)
      win_req.addstr(count.to_s)
      line = line + 1
    end

    win_req.refresh

    line = 5
    versions.each do |name, count|
      win_ver.setpos(line, 2)
      win_ver.addstr('.' * 20)
      win_ver.setpos(line, 2)
      win_ver.addstr(name.to_s + ' ')
      win_ver.setpos(line, 23)
      win_ver.addstr(count.to_s)
      line = line + 1
    end

    win_ver.refresh

    line = 5
    logs.sort_by { |k, v| v[0] }.each do |index, log|
      win_log.setpos(line, 2)
      win_log.addstr(sprintf("%2d : %s", index, log.map(&:to_s).join(' : ')))
      line = line + 1
    end

    win_log.refresh

    sleep 0.5
  end

  win_req.close
ensure
  close_screen
end


target = URI.parse(ARGV[0])
#target = URI.parse('http://35.203.164.211/')
#target = URI.parse('http://35.199.146.193/')
num_workers = ARGV[1].to_i

hosts = {
  failures: 0,
  unknown: 0
}

versions = {
  unknown: 0
}

logs = { }

(1..num_workers).each do |i|
  Thread.new { worker(i, target, hosts, versions, logs) }
end

stats(target, hosts, versions, num_workers, logs)
