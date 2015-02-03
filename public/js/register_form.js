function change_date(){
  year=document.getElementById("year");
  month=document.getElementById("month");
  day=document.getElementById("day");

  vYear=parseInt(year.value);
  vMonth=parseInt(month.value);

  if(vYear!=0&&vMonth!=0){ 
		day.length=0;
		day.options.add(new Option("--","0"))
		max=(new Date(vYear,vMonth,0)).getDate();
		var j;
		for(var i=1;i<=max;i++){ 
		  if(i<10) { j = "0"+i;}else {j=i.toString();}
		  day.options.add(new Option(j,j))
		}
  }
}

function show_hint(){
  email=document.getElementById("regemailinput");
  word=email.value;
  jQuery("#inputInner").css("display","block");
  
  for(var i=2;i<=10;i++){ 
    link= jQuery("#inputInner a:nth-child("+i+")");
    link.html(word+'@'+link.attr("datav"));
  }
}

function copy(i){
  email=document.getElementById("regemailinput");
  link= jQuery("#inputInner a:nth-child("+i+")");
  email.value = link.html();
  jQuery("#inputInner").css("display","none");
}

function check_email(){
  re = /^[a-zA-Z0-9_\.\-]+@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/;
  email = jQuery("#regemailinput").val();
  var rtn;
  if(re.test(email)){
     check_duplicate(email);
     rtn= jQuery("#bool").val()=="true";
  }else{
    rtn=false;
    jQuery("#email_hint").hide();
    jQuery("#email_img").hide();
    jQuery("#emailerrtip div span").html("请填写有效电子邮箱");
    jQuery("#emailerrtip").show();
  }
  return rtn;
}

function check_duplicate(email){
  jQuery.ajax({
		 type: "post",
		 async: "false",
		 url: "/users/ajax_validate",
		 dataType: "json", 
		 data:{validateId: "user_email",validateValue: email},
		 success: function(result, textStatus){
		 handle_check(result, textStatus);		  
		 }
  });
}
 
function handle_check(result, textStatus){
	if(textStatus == "success"){			
		if(result.jsonValidateReturn[2]=="false"){
			jQuery("#email_hint").hide();
		 jQuery("#email_img").hide();
		 jQuery("#emailerrtip div span").html("该邮箱已经注册，请您直接<a class='sl2' target='_blank' href='/login/?email=" + result.jsonValidateReturn[0] + "'>登录</a>或者换一个邮箱");   
		 jQuery("#emailerrtip").show();
		 jQuery("#bool").val("false");
		}else {
		 jQuery("#email_hint").hide();
		 jQuery("#emailerrtip").hide();
		 jQuery("#email_img").css("display","block");
		 jQuery("#bool").val("true");
		}			
	}
}


function test_ajax(){
  var abc = '<%= raw abc.to_json %>';
  jQuery.ajax({
  type:"post",
  //contentType: "application/json", 传过去时的数据类型
  url:"/users/test_ajax",
  dataType: "json", ////WebService 会返回Json类型
  data:{abc: abc, def: "def"},//这里是要传递的参数，格式为 data: "{paraName:paraValue}"
  success:function (result, textStatus) {
		if(textStatus == "success"){
		  //alert(typeof(result.jsonValidateReturn));
		  //alert(result.jsonValidateReturn);
			alert(result.jsonValidateReturn[1]);
		}
   }
  });
}

jQuery(document).ready(function(){ 
  //test_ajax();
});

function check_password(){
  re = /^[a-zA-Z0-9~@#%&_\.\-\^\$\*\!\+\=]{6,16}$/;
  pwd = jQuery("#password").val();
  if(re.test(pwd)){
     var rtn=true;
     jQuery("#pwd_hint").hide();
     jQuery("#pwd_tip").hide();
     jQuery("#pwd_img").css("display","block");
  }else{
    rtn=false;
    jQuery("#pwd_hint").hide();
    jQuery("#pwd_img").hide();
    jQuery("#pwd_tip").show();
  }
  return rtn;
}

function check_confirm(){
  confirm = jQuery("#confirm_password").val();
  pwd= jQuery("#password").val();
  if(pwd!=""&&confirm==pwd){
     var rtn=true;
     jQuery("#confirm_hint").hide();
     jQuery("#confirm_tip").hide();
     jQuery("#confirm_img").css("display","block");
  }else{
    rtn=false;
    jQuery("#confirm_hint").hide();
    jQuery("#confirm_img").hide();
    jQuery("#confirm_tip").show();
  }
  return rtn;
}

function check_name(){
  re = /^[\u4e00-\u9fa5]{2,4}$/;
  name = jQuery("#real_name").val();
  if(re.test(name)){
     var rtn=true;
     jQuery("#name_hint").hide();
     jQuery("#name_tip").hide();
     jQuery("#name_img").css("display","block");
  }else{
    rtn=false;
    jQuery("#name_hint").hide();
    jQuery("#name_img").hide();
    jQuery("#name_tip").show();
  }
  return rtn;
}

function check_birth(){
  year=jQuery("#year").val();
  month=jQuery("#month").val();
  day=jQuery("#day").val();

  if(year!="0"&&month!="0"&&day!="0"){
     var rtn=true;
     jQuery("#birth_tip").hide();
     jQuery("#birth_img").css("display","block");
  }else{
     rtn=false;
     jQuery("#birth_img").hide();
     jQuery("#birth_tip").show();
  }
  return rtn;
}

function check_agree(){
  if(jQuery("#agree").attr("checked")){
    var rtn=true;
    jQuery("#agree_tip").hide();
  }
  else{
    rtn=false;
    jQuery("#agree_tip").show();
  }
  return rtn;
}

function check_form(){
  return check_email()&&check_password()&&check_confirm()&&check_name()&&check_birth()&&check_agree()
}



