require 'Httparty'
require 'Wikipedia'

class FestivalsController <ApplicationController
    include HTTParty
    include Wikipedia
        

    def home

    end

    def index
        @seatgeek = Rails.application.secrets.seat_geek_api_key
        response = HTTParty.get("https://api.seatgeek.com/2/events?sort=score.desc&q=music+festival&per_page=52&client_id=#{@seatgeek}") 
        recent = HTTParty.get("https://api.seatgeek.com/2/events?sort=datetime_utc.asc&q=music+festival&per_page=52&client_id=#{@seatgeek}") 
        near = HTTParty.get("https://api.seatgeek.com/2/events?sort=datetime_utc.asc&q=music+festival&per_page=52&geoip=true&client_id=#{@seatgeek}")
        newly_announced = HTTParty.get("https://api.seatgeek.com/2/events?sort=announce_date.desc&q=music+festival&per_page=25&client_id=#{@seatgeek}")  
        @res = JSON.parse response.to_s, symbolize_names: true
        @recent = JSON.parse recent.to_s, symbolize_names: true
        @near = JSON.parse near.to_s, symbolize_names: true
        @newly = JSON.parse newly_announced.to_s, symbolize_names: true
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

    def profile
        
    end


    def create 
        
    end

    def favorite
        fest_id = params[:id]
        Favorite.create!(fest_id: fest_id, user_id: current_user.id)
        render json: {message: 'created'}
    end


end