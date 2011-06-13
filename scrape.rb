require 'hpricot'
require 'open-uri'

url = "http://gatherer.wizards.com/Pages/"
dom = Hpricot(open("#{url}Search/Default.aspx?output=checklist&set=%5B%22Revised%20Edition%22%5D&sort=abc+").read)
cards = []

dom.search('//table[@class="checklist"]/tr[@class="cardItem"]').each do |tr|
  tr.search('//td[@class="name"]/a').each {|a|
    cards.push(url + a.attributes["href"].sub!("../", ""))
  }
end
puts cards
