class Public::SearchsController < ApplicationController
  skip_before_action :authenticate_customer!

  def index
    search(params[:key])
  end

  #検索
  def search(key)
    #検索はpublic、adminともにできる。ということはadminかそれ以外かで検索対象を変えないといけない
    #検索対象テーブルは以下の通り
    #非admin...genre(アイテムを取得)、item
    #admin...genre(アイテム取得)、item、customer
    #以下の「@~」は全て未取得の場合「.count」が0になる。それをviewで利用する
    if key==""
      @genres=nil
      @items=nil
      @customers=nil
      return
    end

    if !admin_signed_in?
      genre_search(key)
      item_search(key)
    else
      genre_search(key)
      item_search(key)
      customer_search(key)
    end

  end

  #ジャンル検索
  def genre_search(key)
    #処理の流れ
    #1.ジャンル名をライク検索
    #2.ジャンル名,レコードのハッシュを作成。これをのちにビューに渡す
    #3.ヒットしたジャンルそれぞれに対しwhereでアイテムを取得。取得できれば(!=0)ハッシュにジャンル名とともに追加
    #以上
    genres = Genre.where("name LIKE ?", "%"+key+"%")
    if genres.count != 0
      @genres = {}
      genres.each do |genre|
        items = Item.where(genre_id: genre.id)
        if items.count != 0
          @genres.store(genre.name, items)
        end
      end
    end
  end

  #商品検索
  def item_search(key)
    @items = Item.where("name LIKE :requirement OR introduction LIKE :requirement", requirement: "%"+key+"%")
  end

  #顧客検索
  def customer_search(key)
    @customers = Customer.where(
      "last_name LIKE :requirement
      OR first_name LIKE :requirement
      OR last_name_kana LIKE :requirement
      OR first_name_kana LIKE :requirement",
      requirement: "%"+key+"%"
    )
  end
end
