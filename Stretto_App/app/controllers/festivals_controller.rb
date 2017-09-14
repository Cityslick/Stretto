require 'Httparty'
require 'Wikipedia'

class FestivalsController <ApplicationController
    include HTTParty
    include Wikipedia
        

    def home

    end

    def index
        @seatgeek = Rails.application.secrets.seat_geek_api_key
        response = HTTParty.get("https://api.seatgeek.com/2/events?sort=score.desc&q=music+festival&per_page=50&client_id=#{@seatgeek}") 
        @res = JSON.parse response.to_s, symbolize_names: true
    end

    def show
        params[:id]
        @seatgeek = Rails.application.secrets.seat_geek_api_key
        @map = Rails.application.secrets.google_maps_api_key
        response = HTTParty.get("https://api.seatgeek.com/2/events/#{params[:id]}?client_id=#{@seatgeek}") 
        @res = JSON.parse response.to_s, symbolize_names: true
        @performer_id = @res[:performers][0][:id]
        recommendation = HTTParty.get("https://api.seatgeek.com/2/recommendations/performers?performers.id=#{@performer_id}&client_id=#{@seatgeek}")
        @rec = JSON.parse recommendation.to_s, symbolize_names: true
    end


end