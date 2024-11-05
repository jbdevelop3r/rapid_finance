# app/controllers/stocks_controller.rb
class StocksController < ApplicationController
  def intraday
    if params[:symbol].present?
      api = AlphaVantageApi.new
      @intraday_data = api.time_series_intraday(params[:symbol])
      @latest_open_value = @intraday_data.dig('Time Series (5min)').values.first.dig('1. open')
    end
  end

  def create
    last_stock = Stock.where(symbol: stock_params[:symbol]).order(created_at: :desc).first
    @stock = Stock.new(stock_params)

    if last_stock
      @stock.remaining_stock_count = last_stock.remaining_stock_count + @stock.quantity
    else
      @stock.remaining_stock_count = @stock.quantity
    end

    if @stock.save
      redirect_to stocks_path
    else
      redirect_to intraday_stocks_path(symbol: params[:symbol])
    end
  end

  private

  def stock_params
    params.require(:stock).permit(:symbol, :price, :quantity, :remaining_stock_quantity).tap do |whitelisted|
      whitelisted[:quantity] ||= 1  
    end
  end
end
