Rails.application.routes.draw do
  resources :areas do
    # 単数形リソース(resource)なので通常は単数形で書くが、複数のfoodsを取り扱うため複数形で定義している
    resource :foods, only: [:new, :create, :edit, :update], module: :areas, controller: :foods
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'posts#index'
  resources :comics, except: [:destroy]
  resources :posts, only: [:index] do
    collection do
      get 'google_map'
      post 'sort'
    end
  end

  namespace :api do
    get 'postal_code_search/search'
  end

  # コマンドでcontrollerファイルをディレクトリ階層いかに生成した場合、以下のようにルーティングが自動記述される。
  # namespace ディレクトリ名でURLを"/ディレクトリ名/コントローラー名", 見に行くコントローラーも"/ディレクトリ名/コントローラー名"になる。実装によってscopeやscope moduleなどを使い分けるとよい
  namespace :hoge do
    # get 'posts/index'
    resources :posts, only: [:index]
  end

  resources :tweets, only: [:index, :new, :create, :edit, :update]
end
