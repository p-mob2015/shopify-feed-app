class FeedController < ApplicationController
  def show
    begin
      respond_to do |format| 
          format.xml { render file: 'files/feed.xml' } 
      end
    rescue => e
      flash[:error] = "Please import the product list first."
      redirect_to admin_path
    end
  end
end