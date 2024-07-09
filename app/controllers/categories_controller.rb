class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit update destroy ]
  before_action :authorize!
  def index
    authorize!
    @categories = Category.all.order(name: :asc)
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_url, notice: "Category was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_url, notice: "Category was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    alternative_category = Category.where.not(id: @category.id).first
    if alternative_category
    @category.products.update_all(category_id: alternative_category.id)
    @category.destroy!
    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
    end
    else
      respond_to do |format|
        format.html { redirect_to categories_url, notice: "Category cannot be destroyed." }
      end
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    end
end
