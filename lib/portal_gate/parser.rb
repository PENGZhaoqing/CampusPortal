class PortalGate::Parser

  #判断位数数字的位数
  def self.digit(number)
    number.to_s.split('').count
  end

  def self.path_parse(all_nodes, all_path)

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
      temp=(all_path[i]-all_nodes[i])/(10**PortalGate::Parser.digit(all_nodes[i]))

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

  def self.default_traversal(pre_path, parsed_path)

    result= Array.new

    parsed_path.each do |index, path|
      flag=false
      if path.count==pre_path.count+1

        pre_path.each_index do |index|
          if pre_path[index]==path[index]
            flag=true
          else
            flag=false
            break
          end
        end

        if flag
          result<<path.last
        end

      end
    end

    return result.sort!

  end


end
