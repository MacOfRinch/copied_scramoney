class CategoriesController < ApplicationController
  before_action :set_category
  skip_before_action :set_category, only: %i[new create index]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.family_id = @family.id

    if @category.save
      redirect_to family_categories_path, success: "【#{@category.name}】が登録されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @categories = Category.includes(:tasks).where(family_id: @family.id)
  end

  def edit; end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy!
    redirect_to family_categories_path, success: "【#{@category.name}】が削除されました"
  end

  private

  def set_category
    @category = Category.find(params[:id])
    @categories = Category.where(family_id: @family.id)
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
