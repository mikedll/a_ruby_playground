#!/usr/bin/env ruby

ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), '/Gemfile')

require 'rubygems'
require 'bundler/setup'
Bundler.require

conn = PG.connect(dbname: 'baseball')

# conn.exec('create table players (id serial primary key, name varchar(255))') do |res|
#   res.each do |row|
#     puts row
#   end
# end

statment_counter = 0
['Mike Gonzales', 'Sally Sitwell'].each do |name|
  conn.prepare("insert#{statment_counter}", 'insert into players (name) values ($1)')
  conn.exec_prepared("insert#{statment_counter}", [name]) do |res|
    res.each do |row|
      puts row
    end
  end

  statment_counter += 1
end

conn.prepare('my_statement', 'select * from players limit $1')

conn.exec_prepared("my_statement", [20]) do |result|
  result.each do |row|
    puts "#{row['id']}, #{row['name']}"
  end
end


