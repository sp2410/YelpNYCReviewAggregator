Rails.application.routes.draw do
  
  resources :pages, only: [:index] do 
  	collection do
      get 'search'      
    end    
  end

  root 'pages#index'


  
end
