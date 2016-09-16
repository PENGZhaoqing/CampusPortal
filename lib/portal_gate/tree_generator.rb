class PortalGate::TreeGenerator

  def self.newtree(deepth, min_apps=5, max_apps=7, min_app_range=2, max_app_range=10)

    new=Hash.new
    new[0]=[1]
    current_deepth=1
    node=[1]
    parent_id=[]

    loop do

      if current_deepth>deepth
        break
      end

      store=Hash.new
      i=0

      new.each { |index, path|

        #匹配当前深度的上一深度的所有节点
        if path.count==current_deepth-1

          #对上一深度的每一个节点,产生子节点
          x=Random.rand(min_apps..max_apps)

          x_numbers_non_repeat_array=(min_app_range..max_app_range).to_a.sort { rand() - 0.5 }[0..x-2]
          x_numbers_non_repeat_array[1]=1

          node<<x_numbers_non_repeat_array
          node=node.flatten

          x_numbers_non_repeat_array.each { |value|
            local=Array.new(new[index])
            local<<value
            store[i]=[]
            store[i]<<local
            i=i+1
          }
        end
      }

      length=new.length
      (0..store.length-1).each { |i|
        new[i+1+length]=store[i]
        new[i+1+length].flatten!
      }

      current_deepth=current_deepth+1

    end

    new.each { |index, value|
      parent_id<<value.join("")
    }

    parent_id.map! { |n| eval n }

    return node, parent_id

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

          #若找到,跳出循环
          break
        end
      }

    }

    #  parsed_path=> {0=>[1], 1=>[1, 8], 2=>[1, 27], 3=>[1, 3], 4=>[1, 2], 5=>[1, 8, 4], 6=>[1, 8, 9], 7=>[1, 8, 6], 8=>[1, 27, 4], 9=>[1, 27, 7], 10=>[1, 3, 9], 11=>[1, 2, 3]}
    return parsed_path

  end

end