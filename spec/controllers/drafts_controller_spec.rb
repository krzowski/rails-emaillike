require 'rails_helper'

describe DraftsController do
  context "logged in" do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    describe 'GET #index' do
      it "assigns user's drafts to @drafts variable" do
        draft1 = create(:draft, user_id: @user.id)
        draft2 = create(:draft, user_id: @user.id)
        draft3 = create(:draft, user_id: (@user.id + 1))
        get :index
        expect(assigns(:drafts)).to match_array([draft1, draft2])
      end
      it "sets session[:collection] to 'drafts'" do
        get :index
        expect(session[:collection]).to eq("drafts")
      end
    end

    describe "POST #create" do
      context "with valid data" do
        it "creates a database entry" do
          expect { post :create, draft: attributes_for(:draft) }.to change(Draft, :count).by(1)
        end
        it "redirects to newly created draft's path" do
          post :create, draft: attributes_for(:draft)
          expect(response).to redirect_to draft_path(Draft.last.id)
        end
      end

      context "with invalid data" do
        it "doesn't create a database entry" do
          expect { post :create, draft: attributes_for(:draft, title: nil) }.to_not change(Draft, :count)  
        end
        it "renders emails/new template" do
          session[:collection] = 'new_message'  
          post :create, draft: attributes_for(:draft, title: nil)
          expect(response).to render_template('emails/new')
        end
      end
    end

    describe "GET #show" do
      it "assigns demanded draft to @draft" do
        draft1 = create(:draft, user_id: @user.id)
        get :show, id: draft1.id
        expect(assigns[:draft]).to match(draft1)
      end
      it "assigns user's drafts to @drafts variable" do
        draft1 = create(:draft, user_id: @user.id)
        draft2 = create(:draft, user_id: @user.id)
        draft3 = create(:draft, user_id: (@user.id + 1))
        get :show, id: draft1.id
        expect(assigns(:drafts)).to match_array([draft1, draft2])
      end
      it "sets session[:collection] to 'drafts'" do
        draft1 = create(:draft, user_id: @user.id)
        get :show, id: draft1.id
        expect(session[:collection]).to eq("drafts")
      end
    end

    describe "PATCH #update" do
      before :each do
        @draft = create(:draft, user_id: @user.id)
      end
      context "to send an email with send_draft param" do
        context "with valid data" do
          it "destroys the draft's database row" do
            expect { patch :update, {id: @draft.id, send_draft: true, draft: attributes_for(:draft, message: "Send this")} }.to change(Draft, :count).by(-1)
          end
          it "creates email entry in database" do
            expect { patch :update, {id: @draft.id, send_draft: true, draft: attributes_for(:draft, message: "Send this")} }.to change(Email, :count).by(1)
          end
          it "redirects to newly created email's path" do
            patch :update, {id: @draft.id, send_draft: true, draft: attributes_for(:draft, message: "Send this")}
            expect(response).to redirect_to email_path(Email.last)
          end
          it "sets session[:collection] to 'sent'" do
            patch :update, {id: @draft.id, send_draft: true, draft: attributes_for(:draft, message: "Send this")}
            expect(session[:collection]).to eq('sent')
          end
        end

        context "with invalid data" do
          it "displays the error flash" do
            patch :update, {id: @draft.id, send_draft: true, draft: attributes_for(:draft)}
            expect(flash[:danger]).to match("All fields need to be filled to send the message")
          end
          it "renders 'show' template" do
            patch :update, {id: @draft.id, send_draft: true, draft: attributes_for(:draft)}
            expect(response).to render_template('drafts/show')
          end
        end
      end

      context "to update draft" do
        context "with valid data" do
          it "responds with flash[:success] to valid data" do
            patch :update, {id: @draft.id, draft: attributes_for(:draft)}
            expect(flash[:success]).to match("Draft was updated")
          end
          it "responds with flash[:danger] to invalid data" do
            patch :update, id: @draft.id, draft: attributes_for(:draft, title: nil)
            expect(flash[:danger]).to match("To and Title fields need to be filled")
          end
          it "redirects back to the draft" do
            patch :update, {id: @draft.id, draft: attributes_for(:draft)}
            expect(response).to redirect_to draft_path(@draft.id)
          end
        end

        context "with invalid data" do
          it "displays the error flash" do
            patch :update, {id: @draft.id, draft: attributes_for(:draft, title: nil)}
            expect(flash[:danger]).to match("To and Title fields need to be filled")
          end
          it "renders 'show' template" do
            patch :update, {id: @draft.id, draft: attributes_for(:draft, title: nil)}
            expect(response).to render_template('drafts/show')
          end
        end
      end
    end

    describe "DELETE #destroy" do
      before :each do
        @draft = create(:draft, user_id: @user.id)
      end
      it "deletes the database record" do
        expect{delete :destroy, id: @draft.id}.to change(Draft, :count).by(-1)
      end
      it "redirects to drafts path" do
        delete :destroy, id: @draft.id
        expect(response).to redirect_to(drafts_path)
      end
    end
  end

  context "guest access" do
    describe 'GET #index' do
      it 'requires login' do
        get :index
        expect(response).to render_template('users/guest')
      end
    end

    describe "POST #create" do
      it 'requires login' do
        post :create, attributes_for(:draft)
        expect(response).to render_template('users/guest')
      end
    end

    describe "GET #show" do
      it 'requires login' do
        get :show, id: 4
        expect(response).to render_template('users/guest')
      end
    end

    describe "PATCH #update" do
      it 'requires login' do
        patch :update, id: 4
        expect(response).to render_template('users/guest')
      end
    end

    describe "DELETE #destroy" do
      it 'requires login' do
        delete :destroy, id: 4
        expect(response).to render_template('users/guest')
      end
    end
  end
end