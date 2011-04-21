# coding: utf-8
require 'spec_helper'
describe Page do
  
  before(:each) do
    @page = Page.create(:title => "Japan", :address => "Japan", :icon_id => "test.png")
    5.times do |i|
      @page.tags << Tag.create(:name => "Tag #{i}")
    end
  end
  
  it "ページオブジェクトであること" do
    @page.instance_of?(Page).should be_true
  end
  
  it "moveを実行するとページデータがOldPageにコピーされていること" do
    page2 = @page
    @page.move
    old = OldPage.last
    Page.columns.map(&:name).each do |name|
      next if name == "id"
      old[name].should == page2[name]
    end
  end
  
  it "view bodyはMarkdownの実行結果であること" do
    text = <<-EOF
This is Markdown format text.
# Header
## Sub Header
EOF
    @page.body = text
    @page.view_body.should == Kramdown::Document.new(text).to_html
  end
  
  it "view bodyのリンクは自動展開されること" do
    text = <<-EOF
This is Markdown format text.
[[Link]]
# Header
## Sub Header
EOF
    @page.body = text
    text = text.gsub(/\[\[(.*?)\]\]/, "[\\1](/pages/\\1)")
    text = Kramdown::Document.new(text).to_html
    @page.view_body.should == text
  end
  
  it "Get tag list" do
    tags = @page.tags
    @page.categories.should == tags.map(&:name).join(",")
  end
  
  it "Set tag and Get tag" do
    str = "Tag 1,Tag 2,Tag 3,Tag 4"
    @page.categories = str
    @page.reload
    @page.categories.should == str
  end
  
  it "Get Marker ID" do
    @page.marker_id.should == "marker_#{@page.id}"
  end
  
  it "Get Icon path" do
    @page.icon_path.should == "/images/icons/test.png"
  end
end
