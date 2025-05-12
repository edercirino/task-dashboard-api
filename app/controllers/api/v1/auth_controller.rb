module Api
  module V1
    class Api::V1::AuthController < ApplicationController
      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
        token = jwt_encode(user_id: user.id)
        render json:
        { token:, user: { id: user.id, name: user.name, email: user.email } },
        status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def register
        user = User.new(user_params)

        if user.save
          token = jwt_encode(user_id: user.id)
          render json:
          { token:, user: { id: user.id, name: user.name, email: user.email } },
          status: :created
        else
          render json:
          { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def jwt_encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.credentials.secret_key_base)
      end

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
