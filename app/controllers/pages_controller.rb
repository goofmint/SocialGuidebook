class PagesController < ApplicationController
  
  before_filter :get_page
  
  def show
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
      @page = @parent.meta_page unless @page && params[:id] == Page::MetaTitle
    end
    return redirect_to(edit_page_path(@page.title)) if params[:page_id].blank? && @page.new_record?
  end
  
  def create
    @parent = @page
    @page   = @parent.childs.find_by_title(params[:id]) || @parent.childs.new(:title => params[:id])
    @page.attributes = params[:page]
    if @page.save
      @no_element = true
      if request.xhr?
        return render(:action => :edit, :layout => false)
      else
        return redirect_to(page_path(@page.title))
      end
    else
      return render
    end
  end
  
  def edit
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
      @page = @parent.meta_page unless @page && params[:id] == Page::MetaTitle
    end
  end
  
  def update
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
      @page = @parent.meta_page unless @page && params[:id] == Page::MetaTitle
    end
    @page.attributes = params[:page]
    if @page.save
      if request.xhr?
        return render(:action => :show, :layout => false)
      else
        return redirect_to(page_path(@page.title))
      end
    else
      return render(:action => :show)
    end
  end
  
  def destroy
    if params[:page_id]
      @parent = @page
      @page = @parent.childs.find_by_title(params[:id])
    end
    @page.move if @page
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
      @page = Page.new(:title => params[:id], :address => (params[:id] == Page::HomeTitle ? "" : params[:id]))
    end
    unless params[:page_id]
      @page.meta_page = Page.new(:title => Page::MetaTitle, :meta => true) unless @page.meta_page
    end
  end
end
