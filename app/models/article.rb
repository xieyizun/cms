class Article < ActiveRecord::Base

  attr_accessible :title, :content, :view_count, :created_on, :category_id

  belongs_to :user
  belongs_to :category, class_name: 'ArticleCategory', foreign_key: 'category_id'

  validates_presence_of :title, :content, :user_id, :category_id

  default_scope { order('created_on DESC') }

  def self.get_my_articles(current_user)
    ats = current_user.articles.select("id,title,content,created_on,category_id")
    ats_json = articles_to_json(ats, true)
    ats_json
  end

  def self.get_latest_articles
    ats = Article.select("id,title,content,created_on,category_id,user_id")
    ats_json = articles_to_json(ats)
    ats_json
  end

  def self.articles_to_json(ats, my=false)
    ats_json = ats.as_json
    if my
      ats_json.each_with_index do |item, index|
        item['category'] = ats[index].category.name
        item['created_on'] = format_created_on(item['created_on'])
      end
    else
      ats_json.each_with_index do |item, index|
        item['category'] = ats[index].category.name
        item['author'] = ats[index].user.name
        item['created_on'] = format_created_on(item['created_on'])
      end
    end
    ats_json
  end

  def self.get_article_by_id(id)
    article = Article.select("title,content,category_id,created_on,user_id,view_count").where('id='+id)
    article_json = article.first.as_json
    article_json['category'] = article.first.category.name
    article_json.delete("category_id")
    article_json['author'] = article.first.user.name
    article_json.delete("user_id")
    article_json['created_on'] =format_created_on(article_json['created_on'])
    article_json
  end

  def self.format_created_on(time)
    time.localtime.strftime("%Y-%m-%d %H:%M:%S")
  end
end
