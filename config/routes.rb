TestTask::Application.routes.draw do

  resources :queue, :only => [ :index, :create ] do
    collection do
      post 'pop'
      post 'get_task'
    end
  end

  root :to => 'queue#index'

end
