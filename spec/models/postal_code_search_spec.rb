require 'rails_helper'

RSpec.describe PostalCodeSearch, type: :model do
  before do
    # APIへのリクエストを伴うクラスメソッドに対するモック
    api_client = class_double('PostalCodeSearch')
    allow(api_client).to receive(:search).with('1234567').and_return({})
    allow(api_client).to receive(:search).with('1000005').and_return(
      {
        'address1' => '東京都',
        'address2' => '千代田区',
        'address3' => '丸の内',
        'kana1' => 'ﾄｳｷｮｳﾄ',
        'kana2' => 'ﾁﾖﾀﾞｸ',
        'kana3' => 'ﾏﾙﾉｳﾁ',
        'prefcode' => '13',
        'zipcode' => '1000005'
      }
    )
    allow(PostalCodeSearch).to receive(:search).with('1234567').and_return(api_client.search('1234567'))
    allow(PostalCodeSearch).to receive(:search).with('1000005').and_return(api_client.search('1000005'))
  end

  describe '郵便番号検索' do
    it '存在する郵便番号で検索したら、住所などの情報が返ってくること' do
      expect(PostalCodeSearch.search('1000005')).to eq(
        {
          'address1' => '東京都',
          'address2' => '千代田区',
          'address3' => '丸の内',
          'kana1' => 'ﾄｳｷｮｳﾄ',
          'kana2' => 'ﾁﾖﾀﾞｸ',
          'kana3' => 'ﾏﾙﾉｳﾁ',
          'prefcode' => '13',
          'zipcode' => '1000005'
        }
      )
    end

    it '存在しない郵便番号で検索したら、空のハッシュが返ってくること' do
      expect(PostalCodeSearch.search('1234567')).to eq({})
    end
  end
end
