class ProductsController < ApplicationController
    skip_before_action :protect_pages, only: [:index, :show]
    # def index
    #     @categories = Category.order(name: :asc).load_async
    #     @products = Product.with_attached_photo.order(created_at: :desc).load_async
    #     if params[:category_id].present? && Category.exists?(params[:category_id])
    #         @products = @products.where(category_id: params[:category_id])
    #     end
    # end

    def index
        @categories = Category.order(name: :asc).load_async 
        
        # order_by =  Product::ORDER_BY.fetch(params[:order_by]&.to_sym,Product::ORDER_BY[:newest] )

        # @products = Product.with_attached_photo.where(
        # [
        #     params[:min_price].present? ? "price >= #{params[:min_price]}" : nil,
        #     params[:max_price].present? ? "price <= #{params[:max_price]}" : nil,
        #     params[:category_id].present? ? "category_id = #{params[:category_id]}" : nil
        # ].compact.join(" AND ")
        # )

        # @products = @products.search_full_text(params[:query_text]) if params[:query_text].present?

        # @products = @products.order(order_by)
       
        
        @pagy, @products = pagy_countless(FindProducts.new.call(product_params_index), items: 12)
          
        

    end

    def show
        product        
    end

    def up 
        
    end

    def new
        @product = Product.new
    end

    def create
        # @product = Current.user.products.new(product_params)
        @product = Product.new(product_params)
        
        if @product.save
            redirect_to products_path, notice: 'Tu producto se ha creado correctamente'
        else
            render :new, status: :unprocessable_entity
        end
        
    end

    def update
        authorize! product
        if product.update(product_params)
            if @product.previous_changes.present? || params[:product][:photo].present?
                product.broadcast
                redirect_to products_path, notice: 'Tu producto se ha actualizado correctamente'
            else
                render :edit, status: :unprocessable_entity, alert: 'No se realizaron cambios en el producto'
            end
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def edit
        authorize! product
    end
    

    def destroy
        authorize! product
        product.destroy
        redirect_to products_path, notice: 'Tu producto se ha eliminado correctamente', status: :see_other
    end

    private

    def product_params
        params.require(:product).permit(:title, :description, :price, :photo, :category_id)
    end

    def product_params_index
        params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page, :favorites, :user_id)
    end

    def product 
        @product ||= Product.find(params[:id])
    end

    def notify_all_users
         ActionCable.server.broadcast(
            "product_#{product.id}",
            {
                action: "updated"
            }
         )
    end
   
end

##redirect_back(fallback_location: edit_product_path(@product)

# def update
#     @product = Product.find(params[:id])
    
#     if @product.update(product_params)
#         if @product.previous_changes.present?
#             redirect_to products_path, notice: 'Tu producto se ha actualizado correctamente'
#         else
#             render :edit, status: :unprocessable_entity, alert: 'No se realizaron cambios en el producto'
#         end
#     else
#       render :edit, status: :unprocessable_entity
#     end
# end

# if params[:category_id].present? && Category.exists?(params[:category_id])
    #     @products = Product.with_attached_photo.order(created_at: :desc).where(category_id: params[:category_id]).load_async
    # else
    #     @products = Product.with_attached_photo.order(created_at: :desc).load_async
    # end