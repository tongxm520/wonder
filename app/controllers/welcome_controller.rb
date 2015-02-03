# encoding: utf-8

class WelcomeController < ApplicationController
  skip_before_filter :authorize #:except=> :index
  
  def index
    @posts=Post.all
    render :layout=> "search"
  end
  
  def show
    @post = Post.find(params[:id])
    render :layout=> "search"
  end
  
  def login
    if logged_in?
      redirect_to user_path(current_user)
    end
  end
  
  def register
    @user = User.new
  end
  
  def create
    arr = User.authenticate(params[:email],params[:password])
    if arr[0]
      self.current_user= arr[1]
      redirect_to user_path(arr[1])
    elsif arr[1]
      redirect_to login_url, :alert => %Q{帐号尚未激活，请<a target="_blank" href="/users/reactivate?email=#{arr[1].email}">点此激活</a>}
    else
      redirect_to login_url, :alert => "密码或帐号错误"
    end
  end
  
  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to login_url, :alert => "用户已经退出"
  end
 	
  def select
    emails = [ { :name=> "Peter Pan", :to=> "peter@pan.de" },
			{ :name=> "Molly", :to=> "molly@yahoo.com" },
			{ :name=> "Forneria Marconi", :to=> "live@japan.jp" },
			{ :name=> "Master <em>Sync</em>", :to=> "205bw@samsung.com" },
			{ :name=> "Dr. <strong>Tech</strong> de Log", :to=> "g15@logitech.com" },
			{ :name=> "Don Corleone", :to=> "don@vegas.com" },
			{ :name=> "Mc Chick", :to=> "info@donalds.org" },
			{ :name=> "Donnie Darko", :to=> "dd@timeshift.info" },
			{ :name=> "Quake The Net", :to=> "webmaster@quakenet.org" },
			{ :name=> "Dr. Write", :to=> "write@writable.com" }]  
    render :json => { :emails => emails }.to_json
  end
  
  def search
    @posts = search_topics(Post,{},params[:q])
    posts = @posts.map{|p|[p.subject,p.id]}

    render :json => { :data => posts }.to_json
  end
  
  def query
    @posts = search_topics(Post,{},params[:query])
    posts = @posts.map{|p|[p.subject,p.id]}

    render :json => { :data => posts }.to_json
  end
  
  def locate
	  provinces = [{:id=>0, :type=>-1, :name=>"北京"}, {:id=>1, :type=>0, :name=>"云南"},
			{:id=>2, :type=>0, :name=>"贵州"}, {:id=>3, :type=>0, :name=>"四川"},
			{:id=>4, :type=>0, :name=>"内蒙古"}, {:id=>5, :type=>0, :name=>"宁夏"},
			{:id=>6, :type=>0, :name=>"甘肃"}, {:id=>7, :type=>0, :name=>"青海"},
			{:id=>8, :type=>0, :name=>"西藏"}, {:id=>9, :type=>0, :name=>"新疆"},
			{:id=>10, :type=>0, :name=>"安徽"}, {:id=>11, :type=>0, :name=>"浙江"},
			{:id=>12, :type=>0, :name=>"福建"}, {:id=>13, :type=>-1, :name=>"香港"},
			{:id=>14, :type=>-1, :name=>"台湾"}, {:id=>15, :type=>-1, :name=>"澳门"},
			{:id=>16, :type=>0, :name=>"广西"}, {:id=>17, :type=>0, :name=>"广东"},
			{:id=>18, :type=>0, :name=>"江西"}, {:id=>19, :type=>-1, :name=>"上海"},
			{:id=>20, :type=>-1, :name=>"天津"}, {:id=>21, :type=>-1, :name=>"重庆"},
			{:id=>22, :type=>0, :name=>"黑龙江"}, {:id=>23, :type=>0, :name=>"吉林"},
			{:id=>24, :type=>0, :name=>"辽宁"}, {:id=>25, :type=>0, :name=>"山东"},
			{:id=>26, :type=>0, :name=>"山西"}, {:id=>27, :type=>0, :name=>"陕西"},
			{:id=>28, :type=>0, :name=>"河北"}, {:id=>29, :type=>0, :name=>"河南"},
			{:id=>30, :type=>0, :name=>"湖北"}, {:id=>31, :type=>0, :name=>"湖南"},
			{:id=>32, :type=>0, :name=>"海南"}, {:id=>33, :type=>0, :name=>"江苏"}, 
			{:id=>34, :type=>-1, :name=>"海外"}]
			
			cities={"1"=>["昆明", "曲靖", "玉溪", "保山", "昭通", "丽江", "思茅", "临沧", "楚雄彝族自治州", 
			"红河哈尼族彝族自治州", "文山壮族苗族自治州", "西双版纳傣族自治州", "大理白族自治州", 
			"德宏傣族景颇族自治州", "怒江傈僳族自治州", "迪庆藏族自治州"],
		   "2"=> ["贵阳", "六盘水", "遵义", "安顺", "铜仁地区", "黔西南布依族苗族自治州", "毕节地区",
		    "黔东南苗族侗族自治州", "黔南布依族苗族自治州"],
		   "3"=>["成都", "自贡", "攀枝花", "泸州", "德阳", "绵阳", "广元", "遂宁", "内江", "乐山", "南充", 
		   "眉山", "宜宾", "广安", "达州", "雅安", "巴中", "资阳", "阿坝藏族羌族自治州", "甘孜藏族自治州",
		    "凉山彝族自治州"],
		    "4"=>["呼和浩特", "包头", "乌海", "赤峰", "通辽", "鄂尔多斯", "呼伦贝尔", "巴彦淖尔", 
		    "乌兰察布", "兴安盟", "锡林郭勒盟", "阿拉善盟"],
		    "5"=>["银川", "石嘴山", "吴忠", "固原", "中卫"],
		    "6"=>["兰州", "嘉峪关", "金昌", "白银", "天水", "武威", "张掖", "平凉", "酒泉", 
		    "庆阳", "定西", "陇南", "临夏回族自治州", "甘南藏族自治州"],
        "7"=>["西宁", "海东地区", "海北藏族自治州", "黄南藏族自治州", "海南藏族自治州", "果洛藏族自治州", "玉树藏族自治州", "海西蒙古族藏族自治州"],
        "8"=>["拉萨", "昌都地区", "山南地区", "日喀则地区", "那曲地区", "阿里地区", "林芝地区"],
        "9"=>["乌鲁木齐", "克拉玛依", "吐鲁番地区", "哈密地区", "昌吉回族自治州", "博尔塔拉蒙古自治州",
         "巴音郭楞蒙古自治州", "阿克苏地区", "克孜勒苏柯尔克孜自治州", "喀什地区", "和田地区", 
         "伊犁哈萨克自治州", "塔城地区", "阿勒泰地区", "石河子", "阿拉尔", "图木舒克", "五家渠"],
         "10"=>["合肥", "芜湖", "蚌埠", "淮南", "马鞍山", "淮北", "铜陵", "安庆", "黄山", "滁州", 
         "阜阳", "宿州", "巢湖", "六安", "亳州", "池州", "宣城"],
         "11"=>["杭州", "宁波", "温州", "嘉兴", "湖州", "绍兴", "金华", "衢州", "舟山", "台州", "丽水"],
         "12"=>["福州", "厦门", "莆田", "三明", "泉州", "漳州", "南平", "龙岩", "宁德"],
         "16"=>["南宁", "柳州", "桂林", "梧州", "北海", "防城港", "钦州", "贵港", "玉林", "百色", "贺州", "河池", "来宾", "崇左"],
         "17"=>["广州", "韶关", "深圳", "珠海", "汕头", "佛山", "江门", "湛江", "茂名", "肇庆", 
         "惠州", "梅州", "汕尾", "河源", "阳江", "清远", "东莞", "中山", "潮州", "揭阳", "云浮"],
         "18"=>["南昌", "景德镇", "萍乡", "九江", "新余", "鹰潭", "赣州", "吉安", "宜春", "抚州", "上饶"],
         "22"=> ["哈尔滨", "齐齐哈尔", "鸡西", "鹤岗", "双鸭山", "大庆", "伊春", "佳木斯", "七台河", "牡丹江", "黑河", "绥化", "大兴安岭地区"],
         "23"=> ["长春", "吉林", "四平", "辽源", "通化", "白山", "松原", "白城", "延边", "朝鲜族自治州"],
         "24"=>["沈阳", "大连", "鞍山", "抚顺", "本溪", "丹东", "锦州", "营口", "阜新", "辽阳", "盘锦", "铁岭", "朝阳", "葫芦岛"],
         "25"=>["济南", "青岛", "淄博", "枣庄", "东营", "烟台", "潍坊", "济宁", "泰安", "威海", "日照", "莱芜", "临沂", "德州", "聊城", "滨州", "菏泽"],
         "26"=>["太原", "大同", "阳泉", "长治", "晋城", "朔州", "晋中", "运城", "忻州", "临汾", "吕梁"],
         "27"=>	["西安", "铜川", "宝鸡", "咸阳", "渭南", "延安", "汉中", "榆林", "安康", "商洛"],
         "28"=>["石家庄", "唐山", "秦皇岛", "邯郸", "邢台", "保定", "张家口", "承德", "沧州", "廊坊", "衡水"],"29"=>["郑州", "开封", "洛阳", "平顶山", "安阳", "鹤壁", "新乡", "焦作", "济源", "濮阳",
          "许昌", "漯河", "三门峡", "南阳", "商丘", "信阳", "周口", "驻马店"],
          "30"=>["武汉", "黄石", "十堰", "宜昌", "襄樊", "鄂州", "荆门", "孝感", "荆州", "黄冈", 
          "咸宁", "随州", "恩施土家族苗族自治州", "仙桃", "潜江", "天门", "神农架林区"],
          "31"=>["长沙", "株洲", "湘潭", "衡阳", "邵阳", "岳阳", "常德", "张家界", "益阳", 
          "郴州", "永州", "怀化", "娄底", "湘西土家族苗族自治州"],
          "32"=>["海口", "三亚", "五指山", "琼海", "儋州", "文昌", "万宁", "东方", "定安县", "屯昌县", 
          "澄迈县", "临高县", "白沙黎族自治县", "昌江黎族自治县", "乐东黎族自治县", "陵水黎族自治县",
           "保亭黎族苗族自治县", "琼中黎族苗族自治县"],
           "33"=>["南京", "无锡", "徐州", "常州", "苏州", "南通", "连云港", "淮安", "盐城", "扬州", "镇江", "泰州", "宿迁"]
			}
			if params[:type]=="0"
       render :json => { :data => provinces }.to_json
     elsif params[:type]=="1"&&params[:id]
       render :json => { :data => cities[params[:id]] }.to_json
     else
       render :json=>{ :data => {:error=>"无效的参数"} }.to_json
     end
  end
end
