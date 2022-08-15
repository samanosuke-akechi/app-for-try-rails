Rails.application.routes.draw do
  root "posts#index"
  resources :comics, except: [:destroy]
  resources :posts, only: [:index] do
    collection do
      get 'google_map'
    end
  end

  namespace :api do
    get 'postal_code_search/search'
  end

  # コマンドでcontrollerファイルをディレクトリ階層いかに生成した場合、以下のようにルーティングが自動記述される。
  namespace :hoge do # namespace ディレクトリ名でURLを"/ディレクトリ名/コントローラー名", 見に行くコントローラーも"/ディレクトリ名/コントローラー名"になる。実装によってscopeやscope moduleなどを使い分けるとよい
    # get 'posts/index'
    resources :posts, only: [:index]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
