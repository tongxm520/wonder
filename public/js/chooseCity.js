function popup_locate(){
  function clear_curr(id){
    a=jQuery("#"+id).find(".curr");
    for(var i=0;i<a.length;i++)
      a[i].className="";
   }
  
  function select_province(new_id,type,name){
    if(parseInt(type) == -1) {
      locate=document.getElementById("location");
      locate.value=name;
      $("citybox").style.display = "none";
      $("choose_city").style.display = "none";
    }else {
      load_province_city(new_id);
      $("citybox").style.display = "block";
     }
   }
   
  function load_province_city(new_id){
     jQuery.ajax({
			type:"get",
			url:"/welcome/locate",
			dataType: "json", 
			data:{type: "1",id: new_id}, 
			success:function(result, status) {
				if(status == "success"){
				  var a = "";
			    var c=result.data
         a += "<div class=city_list>";
         for (var d = 0; d < c.length; d++) 
           a += '<span><a class="sl" id="city-' + d + '">' + c[d] + "</a></span>";
         a += "</div>";
         jQuery("#citybox").html(a);	
         jQuery("#citybox").find(".sl").click(function() {
				    clear_curr("citybox");
				    this.parentNode.className="curr";
				    locate=document.getElementById("location");
           locate.value=this.innerHTML;
           $("choose_city").style.display = "none";
				  })		
				}
			 }
			});
   }
  
  jQuery.ajax({
  type:"get",
  url:"/welcome/locate",
  dataType: "json", 
  data:{type: "0"}, 
  success:function(result, status) {
		if(status == "success"){
			var a = "";
			var c=result.data
     for (var d = 0; d < c.length; d++) 
       a += '<span><a class="sl2" id="province-' + d + '">' + c[d].name + "</a></span>";
     jQuery("#provincebox").html(a);
     jQuery("#choose_city").css("display","block");
     
     jQuery("#provincebox").find(".sl2").click(function() {
        clear_curr("provincebox");
        this.parentNode.className="curr";
        var id = jQuery(this).attr("id");
        new_id = parseInt(id.split("-")[1]);
        select_province(new_id, c[new_id].type, c[new_id].name);
      })
		}
   }
  });
}


function close_box(){
  $("choose_city").style.display = "none";
}






