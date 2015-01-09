define("apps/reg/CityChoose", ["jQuery"],
function() {
  var b = {
    province: "",
    inited: false,
    bind: "",
    init: function(a) {
      b.bind = a;
      b.initProvince();
      b.adjustPosition();
      b.show()
    },
    adjustPosition: function() {
      var a = $(b.bind).cumulativeOffset(),
      c = a.left - 10;
      a = a.top + 20;
      $("choose_city").setStyle({
        top: a + "px",
        left: c + "px"
      })
    },
    show: function() {
      $("choose_city").style.display = "block"
    },
    hide: function() {
      $("choose_city").style.display = "none"
    },
    initProvince: function() {
      if (b.inited != true) {
        new Ajax.Request("/interface/suggestlocation.php?type=0", {
          method: "get",
          onComplete: b.updateProvinceData
        });
        b.inited = true
      }
    },
    updateProvinceData: function(a) {
      var c = eval("(" + a.responseText + ")");
      a = "";
      for (var d = 0; d < c.length; d++) a += '<span><a class="sl2" data-i="' + d + '">' + c[d].name + "</a></span>";
      $("provincebox").innerHTML = a;
      $j("#provincebox").find(".sl2").click(function() {
        var e = $j(this).data("i");
        b.selectProvince(c[e].id, c[e].type, c[e].name, this)
      })
    },
    selectProvince: function(a, c, d, e) {
      b.province = d;
      var f = $("choose_city").getElementsBySelector(".curr");
      $A(f).each(function(g) {
        g.className = ""
      });
      e.parentNode.className = "curr";
      if (c == -1) {
        $(b.bind).value = d;
        $("citybox").style.display = "none";
        b.hide();
        $j(b.bind).trigger("cityselector:change", [d])
      } else {
        b.loadProvinceCity(a);
        $("citybox").style.display = "block"
      }
    },
    loadProvinceCity: function(a) {
      new Ajax.Request("/interface/suggestlocation.php?type=1&id=" + a, {
        method: "get",
        onComplete: b.updateCityData
      })
    },
    updateCityData: function(a) {
      var c = eval("(" + a.responseText + ")");
      a = "";
      a += "<div class=city_list>";
      for (var d = 0; d < c.length; d++) a += '<span><a class="sl" data-i="' + d + '">' + c[d].name + "</a></span>";
      a += "</div>";
      $("citybox").innerHTML = a;
      $j("#citybox").find(".sl").click(function() {
        var e = $j(this).data("i");
        b.selectCity(c[e].type, c[e].name)
      })
    },
    selectCity: function(a, c) {
      if (a == -1) $(b.bind).value = this.province;
      else $(b.bind).value = c;
      if ($("newcity")) $("newcity").value = 1;
      b.hide()
    }
  };
  return b
});
