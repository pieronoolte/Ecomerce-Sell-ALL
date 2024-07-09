require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
    # def setup 
    #     login
    # end

    setup do 
        login
    end
    test 'render a list of products' do
        get products_path

        assert_response :success
        assert_select '.product', 12
        assert_select '.category', 13
    end

    test 'render a list of products filtered by min price and max price' do
        get products_path(min_price: 100, max_price: 400)

        assert_response :success
        assert_select '.product', 7
    end

    test 'render a list of products filtered by category' do
        get products_path(category_id: categories(:one).id)

        assert_response :success
        assert_select '.product', 2
    end

    test 'search a product by query_text' do
        get products_path(query_text: 'Nintendo')

        assert_response :success
        assert_select '.products .product', 3
    end

    test 'sort products by expensive prices first' do
        get products_path(order_by: 'expensive')

        assert_response :success
        assert_select '.product', 12
        assert_select '.products .product:first-of-type h2', 'Seat Panda clásico'
    end

    test 'sort products by cheapest prices first' do
        get products_path(order_by: 'cheapest')

        assert_response :success
        assert_select '.product', 12
        assert_select '.products .product:first-of-type h2', 'El hobbit'
    end

    test 'render a detailed product page' do
        get product_path(products(:ps4))

        assert_response :success
        assert_select '.title', 'Ps4 Fat'
        assert_select '.description', 'ps4 en buen estado'
        assert_select '.price', '1000'

        if products(:ps4).photo.attached?
            assert_select '.photo', count: 1
        else
            assert_select '.photo', count: 0
        end
    end

    test 'render a new product form' do
        get new_product_path

        assert_response :success
        assert_select 'form'
    end

    test 'allow to create a new product' do
        post products_path, params:{
            product: {
                title: 'Nintendo 64',
                description: 'Nintendo 64',
                price: 45,
                category_id: categories(:one).id
            }
        }

        assert_redirected_to products_path
        assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
    end

    test 'does not allow to create a new product with empty field' do
        post products_path, params:{
            product: {
                title: '',
                description: 'Nintendo 64',
                price: 45
            }
        }

        assert_response :unprocessable_entity
    end

    test 'render an edit product form' do
        get edit_product_path(products(:ps4))

        assert_response :success
        assert_select 'form'
    end

    test 'allow to update a product' do
        patch product_path(products(:ps4)), params:{
            product: {
                price: 150
            }
        }

        assert_redirected_to products_path
        assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
    end

    test 'does not allow to update a product' do
        patch product_path(products(:ps4)), params:{
            product: {
                price: 1000
            }
        }

        assert_response :unprocessable_entity
    end

    test 'can delete products' do
        assert_difference('Product.count', -1) do
            delete product_path(products(:ps4))
        end
        
        assert_redirected_to products_path
        assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
    end
end