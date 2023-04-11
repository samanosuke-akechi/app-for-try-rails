class FoodForm
  include ActiveModel::Model
  FORM_COUNT = 3
  attr_accessor :area, :foods, :consent

  validates :consent, acceptance: true

  def initialize(attributes = {}, area: nil)
    self.consent = attributes.present? ? attributes[:consent] : false
    self.area = area
    self.foods = if attributes.blank? # new, edit
                   initialize_foods(current_foods: area.foods)
                 else # create, update
                   set_attributes(attributes, current_foods: area.foods)
                 end
  end

  def save
    result = true
    ActiveRecord::Base.transaction do
      foods.each do |food|
        result &= check_attributes_and_save_or_destroy(food)
      end
      result &= valid?
      # このクラス自体に設けたバリデーションに引っかかった際のロールバックを発生させるため
      raise ActiveRecord::Rollback unless result
    end
    result
  end

  def update(attributes)
    result = true
    ActiveRecord::Base.transaction do
      attributes[:foods].each_value do |attribute|
        food = initialize_and_set_attributes_food(attribute)
        next if food.nil?

        result &= check_attributes_and_save_or_destroy(food)
        # 更新の場合、保存済みのオブジェクトの配列に初期化した新しいオブジェクトを
        # 以下のように加えるとその時点でinsertが走るのでtransaction内で実行するのがベター
        foods.push(food)
      end
      result &= valid?
      raise ActiveRecord::Rollback unless result
    end
    result
  end

  private

  def initialize_foods(current_foods: [])
    if current_foods.blank? # new
      FORM_COUNT.times.map { area.foods.new }
    else # edit
      current_foods.push((FORM_COUNT - current_foods.size).times.map { area.foods.new }.flatten)
      current_foods
    end
  end

  def set_attributes(attributes, current_foods: [])
    if current_foods.blank? # create
      attributes[:foods].values.map { |attribute| area.foods.new(attribute) }
    else # update
      []
    end
  end

  def initialize_and_set_attributes_food(attribute)
    food = area.foods.find_by(id: attribute[:id].to_i)
    if food.nil?
      # 後置きifはフロントのidが書き換えられた時の対策
      food = area.foods.new(attribute) if attribute[:id].blank?
    else
      # 中間テーブルは保存済みの親テーブルに対してassign_attributesをするとその時点でinsertやdeleteが走る
      # したがって複数テーブル・レコードの更新の時はtransaction内で実行するのがベター
      food.assign_attributes(attribute)
    end
    food
  end

  # 指定フィールドが空かチェックして、すべて空ならdestroy、そうでなければsave
  def check_attributes_and_save_or_destroy(food)
    # 外部キーが入っているパターンで他の値がすべて空の時にvalues.compact.blank?だと弾けないので以下の判定方法を採用
    # nameとpriceがどちらも空の場合はsaveしない
    if food.attributes.values_at('name', 'price').reject(&:blank?).blank?
      food.destroy # destroyの戻り値は空のオブジェクトでもtrue扱いになる
    else
      food.save
    end
  end
end
