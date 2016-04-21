class Category < ActiveRecord::Base
  attr_accessible :name, :description, :lft, :rgt, :level

  has_many :articles, dependent: :destroy

  @connection = ActiveRecord::Base::connection

  #c_or_u: true => create, false => update
  def self.create_or_update_category_by_params(name, description, parent_id, id=nil)
    if parent_id =~ /^-/
      parent_id = 1
    end

    # 查看父节点是否为叶子节点
    parent_lr_distance = @connection.execute("SELECT (rgt - lft) AS distance FROM categories WHERE id=#{parent_id}").first
    distance = parent_lr_distance.first

    # 在叶子节点下新增节点
    if distance == 1
      parent_lft = @connection.execute("SELECT lft FROM categories WHERE id=#{parent_id}").first
      parent_lft = parent_lft.first
      insert_or_update_category(name, description, parent_id, parent_lft, parent_lft+1, parent_lft+2, '>', id)
    else
    # 在非叶子节点下新增节点
      parent_rgt = @connection.execute("SELECT rgt FROM categories WHERE id=#{parent_id}").first
      parent_rgt = parent_rgt.first
      insert_or_update_category(name, description, parent_id, parent_rgt, parent_rgt, parent_rgt+1, '>=', id)
    end

  end

  def self.insert_or_update_category(name, description, parent_id, value, lft, rgt, op, id=nil)
    begin
      ActiveRecord::Base.transaction do
        parent_level = @connection.execute("SELECT level FROM categories WHERE id=#{parent_id}").first

        @connection.execute("UPDATE categories SET rgt = rgt + 2 WHERE rgt #{op} #{value}")
        @connection.execute("UPDATE categories SET lft = lft + 2 WHERE lft > #{value}")
        if id.nil?
          @connection.execute("INSERT INTO categories(name, description, lft, rgt, level)
                         VALUES('#{name}', '#{description}', #{lft}, #{rgt}, #{parent_level.first+1})" )
        else
          @connection.execute("UPDATE categories SET name='#{name}', description='#{description}', lft=#{lft},
                               rgt=#{rgt}, level=#{parent_level.first+1} WHERE id=#{id}")
        end
      end
    rescue Exception => e
      logger.error("insert category #{e.message}")
      return false
    end

    return true
  end

  def self.get_categories_json_tree
    max_level = $redis.get("category:max_level")
    if max_level.nil?
      max_level = @connection.execute("SELECT MAX(level) FROM categories").first
      max_level = max_level.first
      $redis.set("category:max_level", max_level)
    end

    json_tree = $redis.get("categories_json_tree")
    if json_tree.nil?
      json_tree = get_categories_json_tree_from_db
      $redis.set("categories_json_tree", json_tree.to_json)
    else
      json_tree = JSON.parse(json_tree)
    end

    puts json_tree

    [json_tree, max_level]
  end

  def self.get_categories_json_tree_from_db
    result = @connection.execute <<-EOF
          SELECT node.level, parent.id, node.id, node.name
          FROM categories AS node, categories AS parent
          WHERE node.lft BETWEEN parent.lft AND parent.rgt AND node.level = parent.level+1 ORDER BY parent.id
    EOF

    result_array = result.as_json

    json_tree = {}
    has_children_categoreis = Set.new

    result_array.each do |result|
      has_children_categoreis.add(result[1])
    end

    result_array.each do |result|
      if json_tree["#{result[0]}"].nil?
        json_tree["#{result[0]}"] = Array.new
      end

      if has_children_categoreis.include?(result[2])
        json_tree["#{result[0]}"] << { has_children: true, parent_id: result[1], id: result[2], name: result[3] }
      else
        json_tree["#{result[0]}"] << { has_children: false, parent_id: result[1], id: result[2], name: result[3] }
      end
    end

    json_tree
  end

  def self.get_category_detail_by_id(id)
    category = Category.find_by_id(id)
    category_json = category.as_json
    category_json
  end

  def self.update_category_from_params(category_params)
    id = category_params[:id]
    new_name = category_params[:category][:name]
    new_description = category_params[:category][:description]
    new_parent_id = category_params[:category][:parent_id]

    create_or_update_category_by_params(new_name, new_description, new_parent_id, id)
  end

end
