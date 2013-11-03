require "uri"
require "rubygems"
require "bundler/setup"
Bundler.require

hostname = "https://wwws.mint.com/"

unless ARGV.length == 3
  puts "Usage: ruby #{$0} USERNAME PASSWORD TRANSACTION_TYPE"
  exit 1
end

username = ARGV[0]
password = ARGV[1]
tx_type  = ARGV[2]

agent = Mechanize.new
agent.pluggable_parser.default = Mechanize::Download

page  = agent.get(URI.join hostname, "/login.event")
form = page.form_with(:id => "form-login")

form.username = username
form.password = password
form.submit

puts agent.get(URI.join hostname, "/transactionDownload.event").body.split(",")
          .each_with_index.map{|elem,index|elem = elem.gsub(/[\n]/,'').gsub(/[\"]/,'')}
          .each_slice(8).select{|line| line[5] == tx_type}.to_a
