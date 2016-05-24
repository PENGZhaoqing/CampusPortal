require "portal_gate/parser"

module AccessHelper

  def reconstruct(access_params)

    #把node由String转为数组
    node=access_params[:node].split(' ').collect! { |n| n.to_i }

    #把path由String转为数组
    path=[]
    access_params[:path].scan(/\[(.*?)\]/).flatten.each do |item|
      path<<item.split(',').collect! { |n| n.to_i }
    end

    #把path和node结合
    path.each_with_index do |sub_array, index|
      sub_array<<node[index]
    end

    #把path中的数组变为数字(integer)表示
    full_path=[]
    path.each do |sub_array|
      full_path<<sub_array.join('').to_i
    end

    return node, full_path
  end
end
