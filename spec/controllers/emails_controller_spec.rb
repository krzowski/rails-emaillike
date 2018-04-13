require 'rails_helper'

describe EmailsController do
  context "logged in" do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    context "displaying email collection" do
      before :each do
        @email1 = create(:sent_email, user_id: @user.id)
        @email2 = create(:sent_email, user_id: @user.id)
        @email3 = create(:received_email, user_id: @user.id)
        @email4 = create(:received_email, user_id: @user.id)
      end

      describe 'GET #inbox' do
        it "assigns received emails to @emails" do
          get :inbox
          expect(assigns(:emails)).to match_array([@email3, @email4])
        end
        it "renders index page" do
          get :inbox
          expect(response).to render_template("index")
        end
      end

      describe 'GET #sent' do
        it "assigns sent emails to @emails" do
          get :sent
          expect(assigns(:emails)).to match_array([@email1, @email2])
        end
        it "renders index page" do
          get :sent
          expect(response).to render_template("index")
        end
      end

      describe 'GET #show' do
        it "nullifies session[:ajax]" do
          get :show, id: 3
          expect(session[:ajax]).to eq(nil)
        end
        it "assigns session[:collection] type of emails to @emails" do
          session[:collection] = 'sent'
          get :show, id: 3
          expect(assigns(:emails)).to match_array([@email1, @email2])
        end
        it "renders show template" do
          get :show, id: 3
          expect(response).to render_template('show')
        end
      end

      context "in label management" do
        before :each do
          @label1 = create(:label, user_id: @user.id)
          @label2 = create(:label, user_id: @user.id)
          @email1.label = @email3.label = @label1
          @email2.label = @email4.label = @label2
            @email1.save
            @email2.save
            @email3.save
            @email4.save
        end      

        describe 'GET #labeled' do
          it "assigns @emails to accordingly labeled emails" do
            get :labeled, name: @label1.name
            expect(assigns(:emails)).to match_array([@email1, @email3])
          end
          it "renders index template" do
            get :labeled, name: @label1.name
            expect(response).to render_template('index')
          end
        end

        describe 'GET #show' do
          it "assigns emails of corresponding type of label to @emails" do
            session[:collection] = 'label'
            session[:label] = @label2.name
            get :show, id: @email4.id
            expect(assigns[:emails]).to match_array([@email2, @email4])
          end
        end

        describe 'POST #change_label' do
          context "changing label" do
            it "changes email's label" do
              post :change_label, eid: @email1.id, lid: @label2
              @email1.reload
              expect(@email1.label).to eq(@label2)
            end
            it "displays according flash message" do
              post :change_label, eid: @email1.id, lid: @label2
              expect(flash[:success]).to match('Label was assigned')
            end
          end

          context "removing label" do
            it "removes email's label" do
              post :change_label, eid: @email1.id, lid: 'nilthing'
              @email1.reload
              expect(@email1.label).to eq(nil)
            end
            it "displays according flash message" do
              post :change_label, eid: @email1.id, lid: 'nilthing'
              expect(flash[:success]).to match('Label was removed')
            end
          end

          it "changes session[:label] value" do
            session[:label] = @label1.name
            post :change_label, eid: @email1.id, lid: @label2
            expect(session[:label]).to eq(@label2.name)
          end
          it "redirects to current email path" do
            post :change_label, eid: @email1.id, lid: @label2
            expect(response).to redirect_to email_path(@email1.id)
          end
        end
      end

      context "in correspondence" do
        before :each do
          
        end

        describe 'GET #correspondence' do
          it "assigns a whole correspondence with a given person to @emails" do
            get :correspondence, name: @email1.username
            expect(assigns(:emails)).to match_array([@email1, @email2, @email3, @email4])
          end
        end

        describe 'GET #correspondence_to' do
          it "assigns sent emails to a given person to @emails" do
            get :correspondence_to, name: @email1.username
            expect(assigns(:emails)).to match_array([@email1, @email2])
          end
        end

        describe 'GET #correspondence_from' do
          it "assigns received emails from a given person to @emails" do
            get :correspondence_from, name: @email3.username
            expect(assigns(:emails)).to match_array([@email3, @email4])
          end
        end
      end
    end

    describe 'GET #new' do
      it "renders new template" do
        get :new
        expect(response).to render_template('new')
      end
    end

    describe 'POST #create' do
      context "with valid attributes" do
        it "adds a database entry" do
          expect{ post :create, email: attributes_for(:sent_email) }.to change(Email, :count).by(1)
        end
        it "redirects to created email's path" do
          post :create, email: attributes_for(:sent_email)
          expect(response).to redirect_to email_path(Email.last)
        end
      end

      context "with invalid attributes" do
        it "displays flash[:danger] message" do
          post :create, email: attributes_for(:sent_email, title: nil)
          expect(flash[:danger]).to match("Not all fields are filled")
        end
        it "doesn't change database" do
          expect{ post :create, email: attributes_for(:sent_email, title: nil) }.not_to change(Email, :count)
        end
      end

      context "as saved draft" do
        it "doesn't change email table in database" do
          expect{ post :create, email: attributes_for(:email), save_draft: true }.not_to change(Email, :count)
        end
      end
    end

    context "single email operations" do
      before :each do
        @email1 = create(:sent_email, user_id: @user.id)
      end

      describe 'POST #quick_email' do
        context "with valid attributes" do
          it "adds a database entry" do
            expect{ post :quick_email, id: @email1, email: attributes_for(:email) }.to change(Email, :count).by(1)
          end
          it "redirects to created email's path" do
            post :quick_email, id: @email1, email: attributes_for(:email)
            expect(response).to redirect_to email_path(Email.last)
          end
        end

        context "with invalid attributes" do
          it "displays flash[:danger] message" do
            post :quick_email, id: @email1, email: attributes_for(:email, message: nil)
            expect(flash[:danger]).to match("Response has to convey a message")
          end
          it "doesn't change database" do
            expect{ post :quick_email, id: @email1, email: attributes_for(:email, title: nil) }.not_to change(Email, :count)
          end
        end
      end

      describe 'GET #respond' do
        it "renders new template" do
          get :respond, id: @email1
          expect(response).to render_template('new')
        end
      end

      describe 'GET #forward' do
        it "renders new template" do
          get :forward, id: @email1
          expect(response).to render_template('new')
        end
      end


      describe 'DELETE #destroy' do 
        it 'removes a database entry' do
          expect{ delete :destroy, id: @email1 }.to change(Email, :count).by(-1)
        end
        it 'redirects to trash' do
          delete :destroy, id: @email1
          expect(response).to redirect_to(trash_path)
        end
      end
    end


    context "in trash" do
      before :each do
        @email1 = create(:sent_email, user_id: @user.id)
        @email2 = create(:sent_email, user_id: @user.id)
        @email3 = create(:sent_email, user_id: @user.id)
        @email4 = create(:sent_email, user_id: @user.id)
        @email2.trash = @email3.trash = @email4.trash = true
          @email2.save
          @email3.save
          @email4.save
      end

      describe 'GET #trash' do
        it "assigns emails from the trash" do
          get :trash
          expect(assigns(:emails)).to match_array([@email2, @email3, @email4])
        end
        it "renders trash template" do
          get :trash
          expect(response).to render_template('trash')
        end
      end

      describe 'GET #junk' do
        it "renders js" do
          xhr :get, :junk, id: @email3, format: 'js'
          expect(response.content_type).to eq('text/javascript')
        end
      end

      describe 'PATCH #move_to_trash' do
        it "changes trash attribute of an email to true" do
          request.env["HTTP_REFERER"] = root_path
          patch :move_to_trash, id: @email1
          @email1.reload
          expect(@email1.trash).to eq(true)
        end
        it "redirects to previous path" do
          request.env["HTTP_REFERER"] = root_path
          patch :move_to_trash, id: @email1
          expect(response).to redirect_to(root_path)
        end
      end

      describe 'PATCH #move_from_trash' do
        it "changes trash attribute of an email to false" do
          patch :move_from_trash, id: @email2
          @email2.reload
          expect(@email2.trash).to eq(false)
        end
        it "redirects to updated email's path" do
          patch :move_from_trash, id: @email2
          expect(response).to redirect_to(email_path(@email2))
        end
      end
    end
  end

  context "guest access" do
    describe 'GET #inbox' do
      it 'renders guest template' do
        get :inbox
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #sent' do
      it 'renders guest template' do
        get :sent
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #show' do
      it 'renders guest template' do
        get :show, id: 3
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #labeled' do
      it 'renders guest template' do
        get :labeled, name: "something"
        expect(response).to render_template('users/guest')
      end
    end

    describe 'POST #change_label' do
      it 'renders guest template' do
        post :change_label, eid: 5, lid: 76
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #new' do
      it 'renders guest template' do
        get :new
        expect(response).to render_template('users/guest')
      end
    end

    describe 'POST #create' do
      it 'renders guest template' do
        post :create, email: attributes_for(:email, user_id: 2)
        expect(response).to render_template('users/guest')
      end
    end

    describe 'POST #quick_email' do
      it 'renders guest template' do
        post :quick_email, id: 2, email: attributes_for(:email)
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #respond' do
      it 'renders guest template' do
        get :respond, id: 5
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #forward' do
      it 'renders guest template' do
        get :forward, id: 6
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #correspondence' do
      it 'renders guest template' do
        get :correspondence, name: "correspondent"
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #correspondence_to' do
      it 'renders guest template' do
        get :correspondence_to, name: "correspondent"
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #correspondence_from' do
      it 'renders guest template' do
        get :correspondence_from, name: "correspondent"
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #trash' do
      it 'renders guest template' do
        get :trash
        expect(response).to render_template('users/guest')
      end
    end

    describe 'GET #junk' do
      it 'renders guest template' do
        get :junk, id: 6
        expect(response).to render_template('users/guest')
      end
    end

    describe 'PATCH #move_to_trash' do
      it 'renders guest template' do
        patch :move_to_trash, id: 7
        expect(response).to render_template('users/guest')
      end
    end

    describe 'PATCH #move_from_trash' do
      it 'renders guest template' do
        patch :move_from_trash, id: 7
        expect(response).to render_template('users/guest')
      end
    end

    describe 'DELETE #destroy' do 
      it 'renders guest template' do
        delete :destroy, id: 7
        expect(response).to render_template('users/guest')
      end
    end
  end
end