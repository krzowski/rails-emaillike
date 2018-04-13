require 'rails_helper'

describe ContactsController do
  context 'logged in' do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    describe 'GET #index' do
      it "assigns the requested data to @contacts" do
        contact1 = create(:contact, user_id: @user.id)
        contact2 = create(:contact, user_id: @user.id)
        get :index
        expect(assigns(:contacts)).to match_array([contact1, contact2])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template('contacts/index')
      end 
      it "nullifies session[:ajax" do
        get :index
        expect(session[:ajax]).to eq(nil)
      end
    end

    describe 'POST #create' do
      before :each do 
        request.env["HTTP_REFERER"] = email_path(40)
      end
      context "with valid attributes" do
        context "on a normal request" do
          it "redirects back to the email path" do
            post :create, name: 'fds:fds::42*'
            expect(response).to redirect_to(email_path(40))
            expect(flash[:success]).to match "Contact was added"
          end
        end
        context 'within ajax request' do
          it "redirects back to the post" do
            session[:ajax] = 91
            post :create, name: 'fds:fds::42*'
            expect(response).to redirect_to(email_path(91))
            expect(flash[:success]).to match "Contact was added"
          end
        end        
      end
      context "with invalid attributes" do
        context "on a normal request" do
          it "redirects back to the email path" do
            contact = create(:contact)
            post :create, name: contact.name
            expect(response).to redirect_to(email_path(40))
            expect(flash[:danger]).to match "Contact already exists"
          end
        end
        context 'within ajax request' do
          it "redirects back to the post" do
            session[:ajax] = 91
            contact = create(:contact)
            post :create, name: contact.name
            expect(response).to redirect_to(email_path(91))
            expect(flash[:danger]).to match "Contact already exists"
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        request.env["HTTP_REFERER"] = email_path(40)
        @contact = create(:contact, user_id: @user.id)
      end

      it "destroys the record from database" do
        expect { delete :destroy, name: @contact.name }.to change(Contact, :count).by(-1)
      end

      context "redirects to previously visited place: " do
        it "contacts page" do
          request.env["HTTP_REFERER"] = contacts_path
          delete :destroy, name: @contact.name
          expect(response).to redirect_to contacts_path
        end
        it "normal email request" do
          delete :destroy, name: @contact.name
          expect(response).to redirect_to email_path(40)
        end
        it "ajax email request" do
          session[:ajax] = 91
          delete :destroy, name: @contact.name
          expect(response).to redirect_to email_path(91)
        end
      end
    end
  end

  context 'guest access' do
    describe 'GET #index' do
      it "requires login" do
        get :index
        expect(response).to render_template('users/guest')
      end
    end

    describe 'POST #create' do
      it "requires login" do
        post :create, name: 'alle'
        expect(response).to render_template('users/guest')
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete :destroy, name: "alle"
        expect(response).to render_template('users/guest')
      end     
    end
  end
end