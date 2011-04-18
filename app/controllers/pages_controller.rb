class PagesController < ApplicationController
  
  before_filter :get_page
  
  def show
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
      @page = @parent.meta_page unless @page
    end
    return redirect_to(edit_page_path(@page.title)) if params[:page_id].blank? && @page.new_record?
  end
  
  def create
    @parent = @page
    @page   = @parent.childs.find_by_title(params[:id]) || @parent.childs.new(:title => params[:id])
    @page.attributes = params[:page]
    if @page.save
      @no_element = true
      return render(:action => :edit, :layout => false) if request.xhr?
      return redirect_to(page_path(@page.title))
    else
      return render
    end
  end
  
  def edit
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
      @page = @parent.meta_page unless @page
    end
  end
  
  def update
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
      @page = @parent.meta_page unless @page
    end
    @page.attributes = params[:page]
    if @page.save
      if request.xhr?
        return render(:action => :show, :layout => false)
      end
      return redirect_to(page_path(@page.title))
    else
      return render(:action => :show)
    end
  end
  
  def destroy
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
    end
    @old = OldPage.new
    Page.columns.map(&:name).each do |name|
      next if name == "id"
      @old[name] = @page[name]
    end
    if @old.save
      @page.destroy
    end
    if request.xhr?
      return render(:layout => false)
    else
      return redirect_to(root_path)
    end
  end
  
  private
  def get_page
    @page = Page.find_by_title(params[:page_id] || params[:id])
    unless @page
      @page = Page.new(:title => params[:id], :address => (params[:id] == "Home" ? "" : params[:id]))
    end
    unless params[:page_id]
      @page.meta_page = Page.new(:title => "メタ", :meta => true) unless @page.meta_page
    end
  end
end
