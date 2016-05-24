class Access < ActiveRecord::Base
  belongs_to :resource
  has_paper_trail

  serialize :node, Array
  serialize :path, Array

  validates :node, presence: true
  validates :path, presence: true

  validate :check_parseable, on: :update
  validate :check_duplicate_node, on: :update

  def check_duplicate_node
    path.detect { |e|
        if path.count(e)>1
          errors.add(:path,"duplicate node path")
        end
    }
  end

  def check_parseable

    if !path_parse(node, path)
      errors.add(:node,:path, "The node path cannot be parsed")
    end

  end

  def path_parse(all_nodes, all_path)

    #初始化parsed_path,跟nodes的size一致
    parsed_path=Hash.new
    all_nodes.each_index { |i|
      parsed_path[i]=[]
    }

    # root节点设为1
    parsed_path[0]=[1]

    all_nodes.each_index { |i|
      #root 节点已经设为1,所以用next跳过
      next if i==0

      flag=false

      #计算当前节点的父节点的path
      temp=(all_path[i]-all_nodes[i])/(10**digit(all_nodes[i]))

      #寻找父节点,把父节点的path加上现在的节点的值,等于现在节点的path
      (0..i).each { |j|
        if temp==all_path[j]

          # 如果这里用local=parsed_path[j],会导致local跟parsed_path[j]连接起来,
          # 到时候parsed_path[j]会随着local的变化而变化,因此重新声名一个Array,打破连接
          local=Array.new(parsed_path[j])
          local<<all_nodes[i]
          parsed_path[i]=local
          flag=true
          #若找到,跳出循环
          break
        end

      }

      if flag==false
        return false
      end
    }

    return true
  end

  def digit(number)
    number.to_s.split('').count
  end

end
