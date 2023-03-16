module Areas
  class FoodsController < ApplicationController
    before_action :set_area

    def new
      @food_form = FoodForm.new(area: @area)
    end

    def create
      @food_form = FoodForm.new(food_form_params, area: @area)
      if @food_form.save
        redirect_to area_path(@area)
      else
        render :new
      end
    end

    def edit
      @food_form = FoodForm.new(area: @area)
    end

    def update
      @food_form = FoodForm.new(food_form_params, area: @area)
      if @food_form.update(food_form_params)
        redirect_to area_path(@area)
      else
        # エラーメッセージをフロントに表示させたい場合は
        # @food_form.errors.full_messages または 配下のfoodsもバリデーションチェックをしてるので
        # @food_form.foods.each { |food| food.errors.full_messages }で取り出せる
        render :edit
      end
    end

    private

    def set_area
      @area = Area.find(params[:area_id])
    end

    def food_form_params
      params.require(:food_form).permit(:consent, foods: [:id, :area_id, :name, :price, { tag_ids: [] }])
    end
  end
end
