class Api::PostalCodeSearchController < ApplicationController
  require 'net/http'

  def search
    if postal_code = params[:postal_code] # フォームに郵便番号が入力されているとき
      params = URI.encode_www_form({zipcode: postal_code}) # "zipcode=postal_code"という文字列を作ってる
      uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{params}") # APIのURLを代入
      response = Net::HTTP.get_response(uri) # 指定したURLにリクエストを送りレスポンスの取得
      result = JSON.parse(response.body) # レスポンスをjson形式に変換して,そのbody部分を取得
      if result["results"] # 存在しない郵便番号が入力された時は以下の処理はしない
        @zipcode = result["results"].first["zipcode"] # resultsキーのバリューを取得
        @address1 = result["results"].first["address1"]
        @address2 = result["results"].first["address2"]
        @address3 = result["results"].first["address3"]
      end
    end
  end
end
