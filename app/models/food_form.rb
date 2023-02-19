class FoodForm
  include ActiveModel::Model
  FORM_COUNT = 3
  attr_accessor :foods, :consent

  validates :consent, acceptance: true

  def initialize(attributes = {}, area: nil)
    self.consent = attributes[:consent]
    self.foods = if area.present? # edit, update
                   set_foods(area, attributes[:foods])
                 elsif attributes.present? # create
                   attributes[:foods].values.map { |attribute| Food.new(attribute) }
                 else # new
                   initialize_foods
                 end
  end

  def initialize_foods(current_foods: [])
    if current_foods.blank? # new
      current_foods = FORM_COUNT.times.map { Food.new }
    else # edit
      current_foods.push((FORM_COUNT - current_foods.size).times.map { Food.new }.flatten)
    end
    current_foods
  end

  def assign_attributes_for_foods(foods_attributes, current_foods)
    foods_attributes.each_value do |attribute|
      food = current_foods.find { |current_food| current_food.id == attribute[:id].to_i }
      food.nil? ? current_foods.push(Food.new(attribute)) : food.assign_attributes(attribute)
    end
    current_foods
  end

  def set_foods(area, foods_attributes)
    current_foods = area.foods
    return current_foods if current_foods.size == FORM_COUNT && foods_attributes.nil?

    if foods_attributes.present? # update
      assign_attributes_for_foods(foods_attributes, current_foods)
    else # edit
      initialize_foods(current_foods:)
    end
    current_foods
  end

  def save
    ActiveRecord::Base.transaction do
      foods.each do |food|
        # 外部キーが入っているパターンで他の値がすべて空の時にvalues.compact.blank?だと弾けないので以下の判定方法を採用
        # nameとpriceがどちらも空の場合はsaveしない
        if food.attributes.values_at('name', 'price').reject(&:blank?).blank?
          food.destroy! # destroyの戻り値は空のオブジェクトでもtrue扱いになる
        else
          food.save!
        end
      end
      result = valid?
      # このクラス自体に設けたバリデーションに引っかかった際のロールバックを発生させるため
      raise ActiveRecord::Rollback unless result

      result
      # rspecでテストする際に'result &= false'した時にrescueなしだとrollbackしてくれず、
      # 戻り値もfalseではなくnilになってしまうので、rescueを使用した制御を採用。
      # 開発環境だと以下のresucueなしで上記のraiseだけでrollbackしてfalseを返してくれるが、この挙動の差の原因がわからず...
    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
