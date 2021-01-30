class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  def auto_search
     search_item = {name_cont: params[:q],id_eq: params[:q],brand_cont:params[:q],m:'or'}
    @items = Item.ransack(search_item).result(distinct: true)


    respond_to do |format|
      format.html{}
      format.json{
      } 
    end
  end
  def index
    options={}
    options[:conditions]={}
    options.deep_merge!(raw_query:"name ILIKE '%#{params[:item_name]}%'") if params[:item_name].present?
    options.deep_merge!(raw_query:"brand ILIKE '%#{params[:brand]}%'") if params[:brand].present?
    item_ids = Item.joins(:item_category).where("item_categories.id=?",params[:item_category] )if params[:item_category].present?
    options[:conditions].deep_merge!(id:item_ids.pluck(:id)) if item_ids.present? 
    options.deep_merge!(raw_query: "expire_at < '#{Time.now}'") if params[:is_expired]

    @items = Item.where(options[:conditions]).where(options[:raw_query]).order('created_at ASC').paginate(page: params[:page], per_page: 20).where(published: true)
     @filer_reset = (params[:item_categoy].present? || params[:item_name].present? || params[:brand]) ?  true : false
  end

  def new
    @item = Item.new
    respond_to do |format|
      format.js{}
      format.html{}
    end
  end

  def show
  end

  def edit
    respond_to do |format|
      format.js{}
    end
  end

  def create
    @item = Item.new(item_params)
    # @item.published = true

    if @item.save
      flash[:notice] = 'Item was successfully created.'
      respond_to do |format|
        format.html{
          redirect_to @item
        }
        format.js{}
      end
    else
       @errors = @item.errors
      respond_to do |format|
        format.html{
          render action: 'new'
        }
        format.js{
          flash.now[:notice] = @errors.to_a
        }
      end
    end
  end

  def update
    if @item.update(item_params)
      respond_to do |format|
        format.html{
          flash[:notice] = 'Item was successfully updated.'
          redirect_to @item
        }
        format.js{flash.now[:notice] = 'Item was successfully updated.'}
      end
    else
       respond_to do |format|
        format.html{
          render action: 'edit'
        }
        format.js{flash.now[:notice] = @item.errors.to_a}
      end
    end
  end

  def destroy
    @item.published = false
    @item.save

    redirect_to items_url
  end

  def pick_file
    @pick_file = XlsxUploader.new
  end
  
  def import    
    begin
      file = params[:file]
      excel = Creek::Book.new file.path, check_file_extension: true
      # Item.items_import excel
    rescue Exception => e
      @error=e.message
    end
  end


  def search
    @items = Item.all.where('name ILIKE ?', "%#{params[:search][:item_name]}%")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
    @categories = ItemCategory.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:document,
                                 :sku,
                                 :name,
                                 :brand,
                                 :lot,
                                 :manufacture_at,
                                 :expire_at,
                                 :supplier,
                                 :description,
                                 :price,
                                 :stock_amount,
                                 :item_unit,
                                 :cost_price,
                                 :item_category_id,
                                 :supplier_id,
                                 :published)
  end
end
