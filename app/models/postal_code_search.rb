# 郵便番号API(zipcloud)用クラス
class PostalCodeSearch < ApplicationRecord
  require 'net/http'

  include ActiveModel::Model

  def self.search(postal_code)
    return {} if postal_code.blank?

    encoded_postal_code = URI.encode_www_form({ zipcode: postal_code }) # "zipcode=postal_code"という文字列を作ってる
    uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{encoded_postal_code}") # APIのURLを代入
    response = Net::HTTP.get_response(uri) # 指定したURLにリクエストを送りレスポンスの取得
    result = JSON.parse(response.body) # レスポンスをjson形式に変換して,そのbody部分を取得
    return {} if result['results'].blank? # 存在しない郵便番号が入力された時は以下の処理はしない

    result['results'].first
  end
end
