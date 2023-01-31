#!/usr/bin/env ruby
puts ARGV[0].scan(/^([+?A-Za-z0-9]$) (^(\d+)$) (^(\d:\d:\d:\d:\d)$) /).join
