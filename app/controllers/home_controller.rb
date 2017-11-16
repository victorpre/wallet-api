require 'rails/application_controller'

class HomeController < Rails::ApplicationController
  before_action :set_view_path

  respond_to :html

  def index
    render 'index'
  end

  private

  def set_view_path
    prepend_view_path "#{Rails.root}/app/views/"
  end
end
