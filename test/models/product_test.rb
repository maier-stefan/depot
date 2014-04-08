require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
    
  test "product is not valid without a uniqe title" do
    product = Product.new(:title => products(:ruby).title,
    :description => "yyy",
    :price => 1,
    :image_url => "fred.gif")
    
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end
  

 # test "product is not valid without a unique title i18n" do product = Product.new(:title => products(:ruby).title,
  #:description => "yyy", :price => 1, :image_url => "fred.gif")
  
  #assert !product.save
  #assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
  #end
  
  test "product attributes must not be empty" do
  product = Product.new
  assert product.invalid?
  assert product.errors[:title].any?
  assert product.errors[:description].any?
  assert product.errors[:price].any?
  assert product.errors[:image_url].any?
  end
  
  test "product price must be positiv" do
    product = Product.new(:title => "My Poster Title",
                          :description => "yyy",
                          :image_url => "zzz.png")
    
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
    product.errors[:price].join(';')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
    product.errors[:price].join(';')
    
    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(:title => "My Poster Title",
                :description => "yyy",
                :price => 17.00,
                :image_url => image_url)
  end
  
  test "image url" do
    ok = %w{fred.jpg fred.gif fred.png FRED.jpg FRED.png FRED.gif http://a.b/scs/dghw/fred.jpg }
    bad = %w{ fred.gif/more fred.png.more fred.pdf fred.doc }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
    
  end
  
  
  
  
end
