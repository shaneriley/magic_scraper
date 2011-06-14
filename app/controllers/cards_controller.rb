class CardsController < ApplicationController
  require 'hpricot'
  require 'open-uri'

  def index
    @cards = Card.all
  end

  def first_card
    @card = Card.new
    @cards = scrape_list
    @dom = Hpricot(open(@cards[0]))
    @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_cardImage").each {|i|
      @card.image = "http://gatherer.wizards.com/#{i.attributes["src"].sub!("../", "")}"
    }
    @card.name = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_nameRow .value").inner_html.strip
    @card.casting_cost = ""
    @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_manaRow .value img").each do |cost|
      @card.casting_cost += cost.attributes["alt"]
    end
    @card.converted_cost = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_cmcRow .value").inner_html
    @card.card_type = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_typeRow .value").inner_html.strip
    @card.card_text = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_textRow .value").inner_text.strip
    @card.flavor_text = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_flavorRow .value").inner_text.strip
    pt = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_ptRow .value").inner_html
    pt = pt.gsub(/\s/, '').split("/")
    @card.power = pt[0]
    @card.toughness = pt[1]
    @card.series = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_setRow .value a:last-of-type").inner_html
    @card.url = @cards[0]
    @card
  end

  def scrape
    scrape_list(params[:set])
  end

  private
    def scrape_list(set="Revised Edition")
      url = "http://gatherer.wizards.com/Pages/"
      dom = Hpricot(open("#{url}Search/Default.aspx?output=checklist&set=%5B%22#{CGI.escape(set)}%22%5D&sort=abc+").read)
      cards = []

      dom.search('//table[@class="checklist"]/tr[@class="cardItem"]').each do |tr|
        tr.search('//td[@class="name"]/a').each {|a|
          cards.push(url + a.attributes["href"].sub!("../", ""))
        }
      end
      cards.each {|card| create_card(card) }
      redirect_to cards_path
    end

    def create_card(card)
      @card = Card.new
      @dom = Hpricot(open(card))
      @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_cardImage").each {|i|
        @card.image = "http://gatherer.wizards.com/#{i.attributes["src"].sub!("../", "")}"
      }
      @card.name = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_nameRow .value").inner_html.strip
      @card.casting_cost = ""
      @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_manaRow .value img").each do |cost|
        @card.casting_cost += cost.attributes["alt"]
      end
      @card.converted_cost = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_cmcRow .value").inner_html
      @card.card_type = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_typeRow .value").inner_html.strip
      @card.card_text = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_textRow .value").inner_text.strip
      @card.flavor_text = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_flavorRow .value").inner_text.strip
      pt = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_ptRow .value").inner_html
      pt = pt.gsub(/\s/, '').split("/")
      @card.power = pt[0]
      @card.toughness = pt[1]
      @card.series = @dom.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_setRow .value a:last-of-type").inner_html
      @card.url = card
      @card.save
    end
end
