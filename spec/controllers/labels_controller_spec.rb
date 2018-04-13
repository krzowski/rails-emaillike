require 'rails_helper'

describe LabelsController do

  context "logged in" do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    describe 'POST #create' do
      before :each do 
        request.env["HTTP_REFERER"] = 'previous_path'
      end

      context 'with valid attributes' do
        it "creates a new label in database" do
          expect { post :create, attributes_for(:label) }.to change(Label, :count).by(1)
        end
        it "redirects to the previously visited page" do
          post :create, attributes_for(:label)
          expect(response).to redirect_to 'previous_path'
        end
      end

      context 'with invalid attributes' do
        it "fails to create a new label in database" do
          params = { name: nil }
          expect { post :create, params }.to_not change(Label, :count)
        end
        it "redirects to the previously visited page" do
          post :create, {name: "tencharacts"} 
          expect(response).to redirect_to 'previous_path'
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @label = create(:label, user_id: @user.id)  
      end

      it "deletes label from the database" do
        expect{ delete :destroy, id: @label }.to change(Label, :count).by(-1)
      end
      it "redirects to users/manage" do
        delete :destroy, id: @label 
        expect(response).to redirect_to manage_path     
      end
    end
  end

  context "guest access" do
    describe "POST create" do
      it 'requires_login' do
        post :create
        expect(response).to render_template('users/guest')
      end
    end

    describe "DELETE #destroy" do
      it 'requires login' do
        delete :destroy, id: 1
        expect(response).to render_template('users/guest')
      end
    end
  end
end