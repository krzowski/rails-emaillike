require 'rails_helper'

describe UsersController do
  

  context 'logged in' do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    describe 'GET #new' do
      it "redirects to root_path" do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it "redirects to root_path" do
        post :create, attributes_for(:user)
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #manage' do
      it "changes the session[:collection] to 'manage'" do
        get :manage
        expect(session[:collection]).to eq('manage')
      end
    end 

    describe 'PATCH #update' do
      context 'valid password/confirmation data' do
        before :each do
          patch :update, { user: { current_password: build(:user).password, 
                                   password: 'passwdnew', password_confirmation: 'passwdnew' } }
        end
        it "changes user's password" do
          @user.reload                         
          expect(@user.authenticate('passwdnew')).to be_truthy
        end
        it "redirects back to manage_path" do
          expect(response).to redirect_to manage_path
          expect(flash[:success]).to match "Password was changed"
        end
      end

      context 'invalid authentication or password/confirmation data' do
        it "doesn't change password when users fails to authenticate" do
          patch :update, { user: { current_password: (build(:user).password + 'ds'), 
                                   password: 'passwdnew', password_confirmation: 'passwdnew' } }
        end
        it "doesn't change password when users posts invalid data" do
          patch :update, { user: { current_password: build(:user).password, 
                                   password: 'pas', password_confirmation: 'pas' } }
        end
        it "doesn't change password when password/confirmation fields don't match" do
          patch :update, { user: { current_password: build(:user).password, 
                                   password: 'pastats', password_confirmation: 'pastata' } }
        end
      end
    end

    describe 'DELETE #destroy' do
      it "deletes the user data from database" do
        expect{ delete :destroy }.to change(User, :count).by(-1)
      end
      it "clears session[:user_id] and redirects to root_path" do
        delete :destroy
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to root_path
      end 
    end
  end


  context 'guest access' do

    describe 'POST #create' do
      context "with valid data" do
        it "creates an user object" do
          expect{ post :create, { user: attributes_for(:user) } }.to change(User, :count).by(1)
        end

        it "assignes session[:user_id] and redirects to root path" do
          post :create, { user: attributes_for(:user) }
          expect(session[:user_id]).to eq(User.last.id)
          expect(response).to redirect_to root_path
        end
      end
      context "vith invalid data" do
        it "returns signup form" do
          post :create, { user: attributes_for(:user, password: 'dasdafdsfgf') }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'GET #manage' do
      it "requires login" do
        get :manage
        expect(response).to render_template('users/guest')
      end
    end 

    describe 'PATCH #update' do
      it "requires login" do
        patch :manage
        expect(response).to render_template('users/guest')
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete :manage
        expect(response).to render_template('users/guest')
      end
    end
  end
end