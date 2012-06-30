TestTask::Application.routes.draw do

  root :to => 'queue#index'

  match ':controller(/:action(/:id))(.:format)'

end
