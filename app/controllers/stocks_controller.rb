# app/controllers/stocks_controller.rb
class StocksController < ApplicationController
  def intraday
    if params[:symbol].present?
      api = AlphaVantageApi.new
      @intraday_data = api.time_series_intraday(params[:symbol])
      @latest_open_value = @intraday_data
    end
  end
end
