module HomeHelper

  APP_MAP={
      1=>"Discipline Consititution",
      2=>"Teacher Management",
      3=>"Recruitment Management",
      4=>"Registration Center",
      5=>"Registration Management",
      6=>"Status Management",
      7=>"Course Selection",
      8=>"Academic Affairs",
      9=>"Student Activity",
      10=>"Training Guidance",
      11=>"Academic Degree",
      12=>"Employment Management",
      13=>"Alumni Managemen",
      14=>"Accomodation Management",
      15=>"Course Resources",
      16=>"Cloud Classroom"
  }

  def convert_list_to_array(application)
    list=[]
    application.each_with_index { |item, key|
      list<<application[key].id
    }
    return list
  end


  def map_app

  end


end
