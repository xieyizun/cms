class Article < ActiveRecord::Base
  LIMIT_PER_PAGE = 10

  attr_accessible :title, :content, :view_count, :created_on, :category_id, :user_id

  belongs_to :user
  # belongs_to :category, class_name: 'ArticleCategory', foreign_key: 'category_id'
  belongs_to :category

  validates_presence_of :title, :content, :user_id, :category_id

  default_scope { order('created_on DESC') }

  after_save :del_article_and_view_count_from_cache

  def self.get_articles_pages_count
    articles_count = Article.count
    total_pages = articles_count/LIMIT_PER_PAGE+1
    total_pages
  end

  def self.get_my_articles_and_articles_count(current_user, page=1)
    start_index = (page-1)*LIMIT_PER_PAGE
    ats = current_user.articles.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                               .limit("#{start_index},#{LIMIT_PER_PAGE}")
    ats_json = articles_to_json(ats)

    my_articles_count = current_user.articles.count
    total_pages = my_articles_count/LIMIT_PER_PAGE+1

    [ats_json, total_pages]
  end

  def self.get_latest_articles(page=1)
    start_index = (page-1)*LIMIT_PER_PAGE
    ats = Article.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                                              .limit("#{start_index},#{LIMIT_PER_PAGE}")
    ats_json = articles_to_json(ats)
    ats_json
  end

  def self.get_articles_of_one_page(page, current_user=nil, category_id=nil)
    start_index = (page-1)*LIMIT_PER_PAGE
    ats_json = nil

    if current_user.nil?
      if category_id.nil?
        ats = Article.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                .limit("#{start_index},#{LIMIT_PER_PAGE}")
        ats_json = articles_to_json(ats)
      else
        ats = Article.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                  .where('category_id='+category_id).limit("#{start_index},#{LIMIT_PER_PAGE}")
        ats_json = articles_to_json(ats)
      end

    else
      if category_id.nil?
        ats = current_user.articles.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                                                                    .limit("#{start_index},#{LIMIT_PER_PAGE}")
        ats_json = articles_to_json(ats)
      else
        ats = current_user.articles.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                                                           .where('category_id=' + category_id).limit("#{start_index},#{LIMIT_PER_PAGE}")

        ats_json = articles_to_json(ats)
      end
    end

    ats_json
  end

  def self.get_articles_and_articles_pages_count_by_category(category_id, current_user=nil, page=1)
    ats_json = nil
    pages_count = nil
    start_index = (page-1)*LIMIT_PER_PAGE

    if current_user.nil?
      ats = Article.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                                                .where('category_id='+category_id)
                                                .limit("#{start_index}, #{LIMIT_PER_PAGE}")
      ats_json = articles_to_json(ats)

      pages_count = Article.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                        .where('category_id='+category_id).count
    else
      ats = current_user.articles.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                                                              .where('category_id='+category_id)
                                                              .limit("#{start_index}, #{LIMIT_PER_PAGE}")
      ats_json = articles_to_json(ats)

      pages_count =  current_user.articles.includes([:category, :user]).select("id,title,content,created_on,category_id,user_id")
                         .where('category_id='+category_id).count
    end

    pages_count = pages_count/LIMIT_PER_PAGE+1
    [ats_json, pages_count]
  end

  def self.articles_to_json(ats)
    ats_json = ats.as_json
    ats_json.each_with_index do |item, index|
      item['category'] = ats[index].category.name
      item['author'] = ats[index].user.name
      item['created_on'] = format_created_on(item['created_on'])
    end
    ats_json
  end

  def self.get_article_by_id(id)
    article = Article.select("title,content,category_id,created_on,user_id,view_count").where(id: id).first
    article_json = article.as_json
    article_json['category'] = article.category.name
    article_json.delete("category_id")
    article_json['author'] = article.user.name
    article_json.delete("user_id")
    article_json['created_on'] =format_created_on(article_json['created_on'])
    article_json
  end

=begin

  def self.get_article_and_view_count_from_cache(article_id)
    article = Rails.cache.fetch("article:#{article_id}")
    if article.nil?
      article = Article.get_article_by_id(article_id)
      Rails.cache.write("article:#{article_id}", article.to_json)
    else
      article = JSON.parse(article)
    end

    view_count = Rails.cache.fetch("article:#{article_id}:v")
    if view_count.nil?
      view_count = article['view_count']
      Rails.cache.write("article:#{article_id}:v", (value=view_count))
    else
      view_count = Rails.cache.write("article:#{article_id}:v", (value=value+1))
    end

    [article, view_count]
  end
=end

  def self.get_article_and_view_count_from_cache(article_id)
    # 从redis缓存中获取文章
    article = $redis.get("article:#{article_id}")
    if article.nil?
      article = Article.get_article_by_id(article_id)
      $redis.set("article:#{article_id}", article.to_json)
    else
      # 获得hash格式
      article = JSON.parse(article)
    end

    # 递增访问次数
    view_count = $redis.get("article:#{article_id}:v")
    if view_count.nil?
      view_count = article['view_count']
      $redis.set("article:#{article_id}:v", view_count)
    else
      view_count = $redis.incr "article:#{article_id}:v"
    end

    [article, view_count]
  end

  def del_article_and_view_count_from_cache
    #Rails.cache.delete("article:#{self.id}")
    #Rails.cache.delete("article:#{self.id}:v")

    $redis.del("article:#{self.id}")
    $redis.del("article:#{self.id}:v")
  end

  # 使用cron任务,定时更新redis中的view_count到数据库中
  def self.update_view_count
    $redis.keys.each do |key|
      if key =~ /article:[0-9]+:v/
        id = key.split(':').second
        view_count = $redis.get(key).to_i
        article = Article.find(id)
        article.update_column :view_count, view_count
      end
    end
  end

  def self.format_created_on(time)
    time.localtime.strftime("%Y-%m-%d %H:%M:%S")
  end
end
