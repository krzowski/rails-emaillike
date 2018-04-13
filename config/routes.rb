Rails.application.routes.draw do


  root   'emails#inbox'

  # creating new users
  get    '/signup',          to: 'users#new'
  post   '/signup',          to: 'users#create'

  # session handling
  post   '/login',           to: 'sessions#create'
  delete '/logout',          to: 'sessions#destroy'

  # managing existing accounts
  get    '/manage',          to: 'users#manage'
  patch  '/manage',          to: 'users#update'
  delete '/manage',          to: 'users#destroy'

  # contacts
  get    '/contacts',        to: 'contacts#index'
  post   '/contact/:name',   to: 'contacts#create',    as: 'contact',
                                                       constraints: { name: /[^\/]+/ } 
  delete '/contact/:name',   to: 'contacts#destroy',   constraints: { name: /[^\/]+/ }
 
  # email operations
  get    '/inbox',           to: 'emails#inbox'
  get    '/sent',            to: 'emails#sent'
  get    '/label/:name',     to: 'emails#labeled',     as: 'labeled'
  post   'change_label/:eid/:lid',to: 'emails#change_label', as: 'change_label'
  
  get    '/correspondence/:name', to: 'emails#correspondence', 
                                  as: 'correspondence', 
                                  constraints: { name: /[^\/]+/ }
  get    '/correspondence_from/:name', to: 'emails#correspondence_from', 
                                  as: 'correspondence_from', 
                                  constraints: { name: /[^\/]+/ }

  get    '/correspondence_to/:name', to: 'emails#correspondence_to', 
                                  as: 'correspondence_to', 
                                  constraints: { name: /[^\/]+/ }

  get    '/new_email',       to: 'emails#new'
  post   '/new_email',       to: 'emails#create'
  get    '/respond/:id',     to: 'emails#respond',     as: 'respond'
  get    '/forward/:id',     to: 'emails#forward',     as: 'forward'
  get    '/email/:id',       to: 'emails#show',        as: 'email'
  delete '/email/:id',       to: 'emails#destroy' 
  post   '/quick_email/:id', to: 'emails#quick_email', as: 'quick_email'

  get    '/trash',           to: 'emails#trash'   
  get    '/junk/:id',        to: 'emails#junk',            as: 'junk'
  patch  '/to_trash/:id',    to: 'emails#move_to_trash',   as: 'to_trash'
  patch  '/from_trash/:id',  to: 'emails#move_from_trash', as: 'from_trash'

  # draft operations
  resources :drafts, only: [:index, :show, :update, :destroy]

  # labels management
  post   'label',            to: 'labels#create',      as: 'label'
  delete 'label/:id',        to: 'labels#destroy',     as: 'remove_label'




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
