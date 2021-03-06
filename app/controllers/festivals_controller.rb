

class FestivalsController <ApplicationController
    include HTTParty
    include Wikipedia
        

    def home

    end

    def index
        @seatgeek = Rails.application.secrets.seat_geek_api_key || ENV['SEAT_GEEK_API_KEY']
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
        @seatgeek = Rails.application.secrets.seat_geek_api_key || ENV['SEAT_GEEK_API_KEY']
        @map = Rails.application.secrets.google_maps_api_key || ENV['GOOGLE_MAPS_API_KEY']
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
        if user_signed_in?
            @seatgeek = Rails.application.secrets.seat_geek_api_key || ENV['SEAT_GEEK_API_KEY']
            response = HTTParty.get("https://api.seatgeek.com/2/events/#{params[:id]}?client_id=#{@seatgeek}") 
            res = JSON.parse response.to_s, symbolize_names: true
            name = res[:title]
            venue = res[:venue][:name]
            location = res[:venue][:display_location]
            datetime = res[:datetime_local].to_date.strftime("%B %d, %Y")
            fest_id = params[:id]
            Favorite.create!(festival_id: fest_id, user_id: current_user.id, name: name, venue: venue, location: location, datetime: datetime)
        else
        end
    end

    def saved
        @faves = Favorite.where(user_id: current_user.id)
    end

    def deleted
        @faves_delete = Favorite.find(params[:id])
        @faves_delete.destroy
        redirect_to saved_path
    end


end