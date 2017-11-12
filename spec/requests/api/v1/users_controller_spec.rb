require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do

  describe 'GET #show' do

    before(:each) do
      @user = create(:user)

      get api_v1_user_path(@user.id), headers: valid_headers
    end

    it 'returns the user' do
      user_email = as_json(response.body)[:email]
      expect(user_email).to eq @user.email
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do

    context 'when user is succesfully created' do
      before(:each) do
        @user_attributes = attributes_for :user
        post api_v1_users_path, params: { user: @user_attributes }
      end

      it 'returns the created user' do
        user_email = as_json(response.body)[:email]
        expect(user_email).to eq @user_attributes[:email]
      end

      it 'gives the created status code' do
        expect(response).to have_http_status(201)
      end
    end


    context 'when user is not created' do
      before(:each) do
        @not_user_attributes = { name: 'Annonnymous', password: '1234', password_confirmation: '1234' }
        post api_v1_users_path, params: { user: @not_user_attributes }
      end

      it 'returns the errors' do
        user_errors = as_json(response.body)[:errors]
        expect(user_errors).not_to be_empty
      end

      it 'gives the created status code' do
        expect(response).to have_http_status(422)
      end

      context 'when user has duplicated email' do
        before  do
          @user = create :user
          @user_attributes = attributes_for :user
          @user_attributes[:email] = @user[:email]
        end

        subject { post api_v1_users_path, params: { user: @user_attributes } }

        it 'doesnt create the user' do
          expect{ subject }.not_to change{ User.count }
        end
      end
    end
  end


  describe 'PUT #update' do

    context 'when user is updated' do
      before(:each) do
        @user = create(:user)
        @old_name = @user.name
        put api_v1_user_path(@user.id, { user: { name: "not a real name" } } )
      end

      it 'changes the user name' do
        expect(@old_name).not_to eq @user.reload.name
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not updated' do
      before(:each) do
        @user = create(:user)
        @old_name = @user.name
        put api_v1_user_path(@user.id, { user: { name: "" } } )
      end

      it 'doesnt the user name' do
        expect(@old_name).to eq @user.reload.name
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

    end
  end
end
