require 'geokit'
class Page < ActiveRecord::Base
  
  has_many :childs, :foreign_key => :page_id, :class_name => "Page", :conditions => ['meta = ?', false]
  has_one :meta_page,  :foreign_key => :page_id, :class_name => "Page", :conditions => ['meta = ?', true]
  belongs_to :parent_page, :foreign_key => :page_id, :class_name => "Page"
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :page_id
  
  has_many :tags
  
  def view_body
=begin
    self.body.to_s.split(/(\r\n|\r|\n)/).each do |line|
      unless line =~ /^!/
        ary << line
        next
      end
      commands = line.match(/^! (.*?) (.*)$/)
      if commands
        begin
          c = commands[1].split(/::/).inject(Object) {|c,name| c.const_get(name) }
          obj = c.new(commands[2])
          ary << obj.result
        rescue
          ary << line
        end
      end
    end
    self.update_attribute :body, ary.join("\n")
=end
    self.body = self.body.to_s.gsub(/\[\[(.*?)\]\]/, "[\\1](/pages/\\1)")
    Kramdown::Document.new(self.body).to_html
  end
  
  def get_categories
    self.categories.to_s.split(",")
  end
  
  def marker_id
    "marker_#{self.id}"
  end
  
  def icon_path
    "/images/icons/#{self.icon_id}"
  end
  
  def self.icons
    Dir.glob("#{RAILS_ROOT}/public/images/icons/*.png").collect do |filename|
      File::basename(filename)
    end
  end
  
  def info_window
    "<h4><a href='/pages/#{title}'>#{title}</a></h4><p>#{body.to_s.split(//)[0..50]}...</p>"
  end
  
  def get_geo
    @geo = Geocoding.get(self.address)[0]
    if @geo
      self.latitude = @geo.latitude
      self.longitude = @geo.longitude
    end
  end
  
  def all_childs
    childs + follow_pages
  end
  
  def all_childs_and_has_position
    return @childs_has_position if @childs_has_position
    @childs_has_position = []
    childs.each do |child|
      next unless child.has_position?
      @childs_has_position << child
    end
    @childs_has_position
  end
  
  def get_marker(add_options = {})
    if self.new_record?
      options = {:title => title, :info_window => "#{info_window}", :draggable => true, :name => marker_id}
    else
      options = {:title => title, :info_window => "#{info_window}", :name => marker_id, :icon => get_icon}
    end
    options = options.merge(add_options)
    return GMarker.new([latitude, longitude], options) if self.has_position?
    if parent_page
      return GMarker.new([parent_page.latitude, parent_page.longitude], options)
    else
      return GMarker.new([self.latitude, self.longitude], options)
    end
    return nil
  end
  
  def get_icon
    icon = icon_id.blank?? nil : GIcon.new(:image => icon_path, :copy_base => GIcon::DEFAULT, :icon_size => GSize.new(32, 37), :icon_anchor => GPoint.new(15, 34))
  end
  
  def map(add_options = {})
    return @map if @map
    return nil if !self.has_position? && !self.parent_page.nil?
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    get_geo unless self.has_position?
    @map.center_zoom_init([self.latitude, self.longitude], (all_childs_and_has_position.size == 0 ? 7 : 4))
    @map.overlay_init get_marker(add_options)
    return @map if self.new_record?
    all_childs.each do |child|
      next unless child.has_position?
      @map.overlay_init child.get_marker
    end
    @map
  end
  
  def categories
    self.tags.map(&:name).join(",")
  end
  
  def categories=(tag_list)
    tag_list = tag_list.gsub("　", " ").gsub("、", ",").gsub(", ", ",")
    exists = self.tags.map(&:name)
    new_tags = []
    tag_list.split(",").each do |tag|
      if exists.include?(tag)
        exists.delete(tag)
      else
        new_tags << tag
      end
    end
    exists.each do |name|
      self.tags.find_by_name(name).destroy
    end
    new_tags.each do |name|
      self.tags << Tag.new(:name => name)
    end
  end
  
  def follow_pages
    Tag.all(:conditions => ["tags.name = ? and tags.page_id <> ?", self.title, self.id], :include => :page).collect do |tag|
      tag.page
    end.uniq
  end
  
  def get_position!
    get_position
    save(:validate => false)
  end
  
  def get_position
    return nil if self.address.blank?
    begin
      a=Geokit::Geocoders::GoogleGeocoder.geocode self.address
      self.latitude, self.longitude = a.ll.split(",")
    rescue
    end
  end
  
  def has_position?
    self.latitude != 0.0 && self.longitude != 0.0
  end
end
