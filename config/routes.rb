Rails.application.routes.draw do
    root 'static#index'
    get 'static/index' => 'static#index'
    get 'static/about' => 'static#about'
    get 'index' => 'static#index'

    get     '/auth/:provider/callback', to: 'sessions#create'
    get     'login'   => 'sessions#new'
    post    'login'   => 'sessions#create'
    delete  'logout'  => 'sessions#destroy'
    
    
    resources :album do
        get "delete"
    end
    get 'albums/search' =>   'album#search'
    get 'albums/addAlbum', to: 'album#addAlbum'   
    post 'albums/updateRowOrder', to: 'album#updateRowOrder'   

    resources :track do
        get "delete"
    end    
    
    get 'album_listing/numbered' => 'album_listing#numbered'
    get 'album_listing/unnumbered' => 'album_listing#unnumbered'    
    resources :album_listing
    
    delete 'album_listing/delete' => 'album_listing#destroy'

    get   'card/edit' => 'card#edit'
    patch 'card/'     => 'card#update'
    get   'card'      => 'card#index'
end
