module Api
  module V1
    class  UsersController < BaseController
      respond_to :json

      before_action :require_login!, except: [:create]

      def show
        render json: User.find(params[:id])
      end

      def create
        @user = User.create(user_params)
        if @user.save
          render json: @user, status: 201
        else
          render json: { errors: @user.errors }, status: 422
        end
      end

      def update
        @user = User.find(params[:id])
        if @user == current_user && @user.update(user_params)
          render json: @user, status: 200
        else
          render json: { errors: @user.errors }, status: 422
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
