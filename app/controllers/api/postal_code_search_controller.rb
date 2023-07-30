module Api
  class PostalCodeSearchController < ApplicationController
    def search
      result = PostalCodeSearch.search(params[:postal_code])
      @zipcode = result['zipcode']
      @address1 = result['address1']
      @address2 = result['address2']
      @address3 = result['address3']
    end
  end
end
