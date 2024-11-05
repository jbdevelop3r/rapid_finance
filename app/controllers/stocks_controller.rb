# app/controllers/stocks_controller.rb
class StocksController < ApplicationController
  def search
    if params[:keywords].present?
      api = AlphaVantageApi.new(ENV['RAPIDAPI_KEY'])
      @search_results = api.symbol_search(params[:keywords])
    else
      @search_results = { error: "Keywords are required" }
    end
  end

  def intraday
    if params[:symbol].present?
      api = AlphaVantageApi.new(ENV['RAPIDAPI_KEY'])
      @intraday_data = api.time_series_intraday(params[:symbol])
      @latest_open_value = @intraday_data.dig("Time Series (5min)")&.values.first.dig('1. open')
    else
      @intraday_data = { error: "Symbol is required" }
    end
  end
end
