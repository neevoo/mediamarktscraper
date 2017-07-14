class DashboardsController < ApplicationController

  #============================================================================================================
  #============================================================================================================
  #===================================================ALLGEMEINER TEIL=========================================
  #============================================================================================================
  #============================================================================================================
  
  class Entry
    def initialize(title, link, redakteur, lokal, datum, person, comment_number, comment_link, temperatur)
      @title = title
      @link = link
      @lokal = lokal
      @datum = datum
      @person = person
      @comment_number = comment_number
      @comment_link = comment_link
      @temperatur = temperatur
      @redakteur = redakteur
    end
    attr_reader :title
    attr_reader :link
    attr_reader :lokal
    attr_reader :datum
    attr_reader :person
    attr_reader :comment_number
    attr_reader :comment_link
    attr_reader :temperatur
    attr_reader :redakteur
  end
  
  #============================================================================================================
  #============================================================================================================
  #===================================================ALLGEMEINER TEIL ENDE====================================
  #============================================================================================================
  #============================================================================================================

  
  def dashboard_1
  end

  def dashboard_2
  end

  def dashboard_3
    @extra_class = "sidebar-content"
  end

  def dashboard_4
    render :layout => "layout_2"
  end

  def dashboard_4_1
  end

  def dashboard_5
  end
#-----------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------MYDEALZ SCRAPER---------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

  def scrape_mydealz
    require 'open-uri'
  	urlarray = Array.new
  	# ---------------------------------------------------------------   URL erstellen
  	pagination = '&page=1' 
  	count = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  	count.each do |i|
  		base_url = "https://www.mydealz.de/search?q=media+markt"
  		pagination = "&page=#{i}"
  		combination = base_url + pagination
  		urlarray << combination
  	end
  	# --------------------------------------------------------------- / URL erstellen
    
    @entriesArray = []

  	urlarray.each do |u|
      doc = Nokogiri::HTML(open("#{u}"))
      entries = doc.css('article.thread')
      entries.each do |entry|
        title = entry.css('a.vwo-thread-title').text
        link = entry.css('a.vwo-thread-title')[0]['href']
        person = entry.css('span.thread-username').text
        lokal = entry.css('a.vwo-thread-title')[0]['href']
        if lokal.include? 'lokal'
          lokal = "im Markt"
        else
          lokal = "online"
        end
        datum = entry.css('span.hide--fromW3').text.delete "Deal"
        datum_1 = (entry.css('time.mute--text')[0]['datetime']).to_i
        datum = Time.at(datum_1)
        temperatur = entry.css('div.vwo-vote').text.delete "°ABGELAUFEN"
        temperatur.to_i
        if temperatur > 800
          temperatur
        if redakteur = entry.css('span.text--backgroundPill').text.empty?
          redakteur =  'MD-User' # entry.css('span.text--backgroundPill').text
        else
          redakteur = entry.css('span.text--backgroundPill').text
        end
      
      comment_number = entry.css('a.cept-comment-link').text.delete 'Kommentare'
      comment_number.to_i
      comment_link = entry.css('a.cept-comment-link')[0]['href']
        @entriesArray << Entry.new(title, link, redakteur, lokal, datum, person, comment_number, comment_link, temperatur)
      end
    end
      render template: '/dashboards/scrape_mydealz'
  end
  
#-----------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------END MYDEALZ SCRAPER---------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

end
