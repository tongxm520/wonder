K.App("reg/ARegister", ["apps/reg/Captcha", "core/valid/Valid", "apps/reg/CityChoose"]).define(function(l) {
  var b = l("jQuery"),
  r = l("apps/reg/Captcha"),
  m = l("core/valid/Valid");
  l = "http://" + K.Env.KX_HOST;
  var p = {
    nickname: {
      0 : true,
      1 : '\u8bf7\u8f93\u51655-18\u4f4d\u7684\u5b57\u6bcd\u3001\u6570\u5b57\u6216\u4e0b\u5212\u7ebf\u53ca\u7ec4\u5408\uff0c\u5efa\u8bae\u7528<strong class="cr">QQ\u53f7\u3001\u624b\u673a\u53f7</strong>\u4e3a\u4f60\u7684\u8d26\u53f7\uff0c\u8fd9\u6837\u4e0d\u6613\u5fd8\u8bb0\u4f60\u7684QQ\u53f7\u6216\u624b\u673a\u53f7\u5c06\u88ab\u4e25\u683c\u4fdd\u5bc6\uff0c\u8bf7\u653e\u5fc3\u4f7f\u7528',
      2 : '\u8be5\u7528\u6237\u540d\u5df2\u88ab\u4f7f\u7528\uff0c\u8bf7\u76f4\u63a5<a href="' + l + '/login/?nickname=" class="sl2">\u767b\u5f55</a>\u6216\u8005\u6362\u4e2a\u540d\u5b57',
      3 : "\u8d26\u53f7\u683c\u5f0f\u6709\u8bef\uff01\u7528\u6237\u540d\u53ea\u80fd\u7531\u5b57\u6bcd\u3001\u6570\u5b57\u6216\u4e0b\u5212\u7ebf\u7ec4\u6210",
      4 : "\u8be5\u624b\u673a\u53f7\u5df2\u7ecf\u7ed1\u5b9a\u4e86\u67d0\u5f00\u5fc3\u7f51\u8d26\u6237\uff0c\u8bf7\u6362\u4e00\u4e2a\u8d26\u53f7\u6ce8\u518c",
      5 : "\u8d26\u53f7\u683c\u5f0f\u6709\u8bef\uff01\u7528\u6237\u540d\u53ea\u80fd\u4ee5\u5b57\u6bcd\u6216\u6570\u5b57\u5f00\u5934",
      6 : "\u8d26\u53f7\u683c\u5f0f\u6709\u8bef\uff01\u7528\u6237\u540d\u53ea\u80fd\u4ee5\u5b57\u6bcd\u6216\u6570\u5b57\u7ed3\u5c3e",
      7 : "\u8d26\u53f7\u683c\u5f0f\u6709\u8bef\uff01\u7528\u6237\u540d\u81f3\u5c11\u9700\u89815\u4f4d\u5b57\u7b26",
      8 : "\u8d26\u53f7\u683c\u5f0f\u6709\u8bef\uff01\u7528\u6237\u540d\u4e0d\u80fd\u8d85\u8fc718\u4f4d\u5b57\u7b26",
      10 : "\u8be5\u7528\u6237\u540d\u5df2\u7ecf\u5728\u5f00\u5fc3\u7f51\u6ce8\u518c",
      11 : "\u8be5\u7528\u6237\u5df2\u7ecf\u88ab\u5220\u9664",
      12 : '\u4f60\u8f93\u5165\u7684\u4e3a\u624b\u673a\u53f7\uff0c\u8bf7\u524d\u5f80<a href="' + l + '/register/index.php?rg=mobile&nickname=" class="sl2">\u624b\u673a\u6ce8\u518c</a>',
      13 : "\u624b\u673a\u53f7\u7801\u4e3a11\u4f4d\u6570\u5b57\uff0c\u4ee513/14/15/18\u5f00\u5934",
      14 : '\u8be5\u53f7\u7801\u5df2\u7ecf\u88ab\u6ce8\u518c\uff0c\u8bf7\u76f4\u63a5<a href="' + l + '/login/?nickname=" class="sl2">\u767b\u5f55</a>\uff0c\u5982\u5fd8\u8bb0\u5bc6\u7801\uff0c\u53ef\u77ed\u4fe1\u53d1\u90016-16\u4f4d\u6570\u5b57\u81f3106901606688\u91cd\u7f6e\u5bc6\u7801'
    },
    email: {
      0 : true,
      1 : '<b class="color-red">\u91cd\u8981\uff01</b>\u8bf7\u586b<b class="color-red">\u6709\u6548\u90ae\u7bb1\u5730\u5740</b>\uff0c\u4ee5\u9a8c\u8bc1\u5b8c\u6210\u6ce8\u518c</b>\u6b64\u90ae\u7bb1\u5730\u5740\u5c06\u5373\u662f\u4f60\u7684\u5f00\u5fc3\u7f51\u767b\u5f55\u8d26\u53f7',
      2 : '\u8be5\u90ae\u7bb1\u5df2\u7ecf\u6ce8\u518c\uff0c\u8bf7\u60a8\u76f4\u63a5<a href="' + l + '/login/?email=" class="sl2">\u767b\u5f55</a>\u6216\u8005\u6362\u4e00\u4e2a\u90ae\u7bb1',
      3 : "\u8be5Email\u6ce8\u518c\u7684\u5f00\u5fc3\u8d26\u6237\u5df2\u5220\u9664\uff0c\u4e14\u4e0d\u53ef\u6062\u590d\u8bf7\u4f7f\u7528\u5176\u4ed6Email\u91cd\u65b0\u6ce8\u518c\u65b0\u7684\u5e10\u6237",
      4 : "\u62b1\u6b49\u6682\u4e0d\u652f\u6301\u8be5\u540e\u7f00\u7684\u90ae\u7bb1\u6ce8\u518c",
      5 : "Email\u683c\u5f0f\u6709\u8bef\uff0c\u8bf7\u91cd\u8f93",
      6 : "\u8be5Email\u6ce8\u518c\u7684\u5f00\u5fc3\u8d26\u6237\u5df2\u505c\u7528\uff0c\u5982\u9700\u6062\u590d\u8be5\u5e10\u6237\uff0c\u8bf7\u81ea\u5220\u9664\u65e5\u8d775\u5929\u540e\u6765\u6ce8\u518c",
      7 : '\u8be5Email\u6ce8\u518c\u7684\u5f00\u5fc3\u8d26\u6237\u5df2\u505c\u7528\uff0c\u5982\u9700\u6062\u590d\u8be5\u5e10\u6237\uff0c\u8bf7<a href="' + l + '/set/resume.php?email=" class="sl2">\u70b9\u51fb\u8fd9\u91cc</a>'
    },
    real_name: {
      0 : true,
      1 : '\u8bf7\u4e00\u5b9a\u586b\u5199\u4f60\u7684<b class="color-red">\u771f\u5b9e\u4e2d\u6587\u59d3\u540d</b>\uff0c\u4ee5\u65b9\u4fbf\u670b\u53cb\u8054\u7edc\uff0c \u9ed8\u8ba4\u8bbe\u7f6e\u4e0b\uff0c\u53ea\u6709\u4f60\u7684\u719f\u4eba\u624d\u80fd\u770b\u5230\u4f60\u7684\u8d44\u6599',
      4 : "\u59d3\u540d\u53ef\u80fd\u542b\u6709\u8fdd\u7981\u5185\u5bb9",
      "default": "\u8bf7\u586b\u5199\u771f\u5b9e\u4e2d\u6587\u59d3\u540d"
    }
  };
  return {
    events: {
      "submit form[name=regform]": "onSubmit",
      "click .toAccount": "toAccount",
      "click .toEmail": "toEmail",
      "keyup input[name=email]": "onEmailSuggest",
      "focus input[name=email]": "onEmailSuggest",
      "blur input[name=email]": "hideEmailSuggest",
      "click a.sl2": "setLocation",
      "click a.preslemail": "setEmailValue",
      "change select[name=year]": "showCaptcha"
    },
    showCaptcha: function() {
      if ($j(".captchadiv").is(":hidden")) {
        $j(".captchadiv").show(); (new r).changeRcode2()
      }
    },
    onEmailSuggest: function(c) {
      c = $j(c.currentTarget).val();
      if (c.length != c.replace(/[^\x00-\xff]/g, "**").length) $j("#inputInner").hide();
      else {
        var h = c.split("@");
        if (c) {
          $j("#inputInner").show();
          $j("#selectBox").hide();
          $j(".preslemail").each(function() {
            var n = b(this).attr("datav");
            b(this).show();
            h[1] && n.indexOf(h[1]) == -1 && b(this).hide();
            b(this).text(h[0] + "@" + n)
          })
        } else $j("#inputInner").is(":hidden") || $j(".preslemail").each(function() {
          var n = b(this).attr("datav");
          b(this).text("@" + n)
        })
      }
    },
    hideEmailSuggest: function() {
      setTimeout(function() {
        $j("#inputInner").hide();
        $j("#selectBox").show()
      },
      200)
    },
    setEmailValue: function(c) {
      c.preventDefault();
      $j("#emailerrtip").hide(); (c = $j(c.currentTarget).text()) && b("input[name=email]").val(c);
      $j("#inputInner").hide();
      $j("#selectBox").show();
      b("input[name=email]").focus()
    },
    setLocation: function(c) {
      var h = b(c.currentTarget).attr("href");
      if (h) if (h.indexOf("email=") != -1) {
        c.preventDefault(c);
        document.location = h + document.regform.email.value
      } else if (h.indexOf("nickname=") != -1) {
        c.preventDefault(c);
        document.location = h + document.regform.nickname.value
      }
    },
    toAccount: function(c) {
      c.preventDefault();
      b(c.currentTarget).parent().parent().parent().hide();
      c = b("input[name=email]").attr("disabled", "disabled").val();
      if (c.indexOf("@") >= 0) c = c.split("@")[0];
      b("input[name=nickname]").removeAttr("disabled").val(c);
      b("input[name=nickname]").parent().parent().parent().show();
      b("input[name=nickname]").focus()
    },
    toEmail: function(c) {
      c.preventDefault();
      b(c.currentTarget).parent().parent().parent().hide();
      c = b("input[name=nickname]").attr("disabled", "disabled").val();
      b("input[name=email]").removeAttr("disabled").val(c).parent().parent().parent().show();
      b("input[name=email]").focus()
    },
    onSubmit: function(c) {
      c.preventDefault();
      b("input[type=submit]").attr("disabled", true);
      m.on("aftercheckall",
      function() {
        b("input[type=submit]").removeAttr("disabled")
      });
      m.doCheckAll(document.regform, K.bind(this.submit, this))
    },
    submit: function() {
      b("input[type=submit]").attr("disabled", true);
      b("#submit_tip").show();
      b.post("/register/aj_submit.php", b(document.regform).serialize(),
      function(c) {
        b("input[type=submit]").removeAttr("disabled");
        b("#submit_tip").hide();
        if (c.succ == 1) window.location = "http://www.kaixin001.com" + c.data.location;
        else { (new r).changeRcode2();
          m.forceServerCheck(document.regform)
        }
      },
      "json")
    },
    main: function() {
      function c() {
        var a = n[0],
        d = q[0],
        e = h[0].value;
        if (e != "") {
          e = parseInt(e, 10);
          var i = new Date,
          k = i.getFullYear(),
          j = 12,
          o = a.value,
          f,
          g;
          if (o == "") {
            if (k == e) j = i.getMonth() + 1;
            f = a.options;
            f[0].value = "";
            f[0].text = "";
            for (g = 1; g <= j; g++) {
              a = g.toString();
              a = a.length == 1 ? "0" + a: a;
              f.length = g + 1;
              f[g].value = a;
              f[g].text = a
            }
          } else {
            o = parseInt(o, 10);
            if (k == e) j = i.getMonth() + 1;
            f = a.options;
            f[0].value = "";
            f[0].text = "";
            for (g = 1; g <= j; g++) {
              a = g.toString();
              a = a.length == 1 ? "0" + a: a;
              f.length = g + 1;
              f[g].value = a;
              f[g].text = a;
              if (g == o) f[g].selected = true
            }
            j = d.value;
            f = getDays(e, o);
            a = i.getMonth() + 1;
            if (k == e && a == o) f = i.getDate();
            e = d.options;
            e[0].value = "";
            e[0].text = "";
            for (d = 1; d <= f; d++) {
              a = d.toString();
              a = a.length == 1 ? "0" + a: a;
              e.length = d + 1;
              e[d].value = a;
              e[d].text = a;
              if (j <= f && d == j) e[d].selected = true
            }
          }
        }
      }
      b("input[name=email]").data("src") != "login" && b("input[name=email]").focus();
      var h = b("select[name=year]"),
      n = b("select[name=month]"),
      q = b("select[name=day]"),
      s = new r;
      $j("#regemailinput").bind("keyup",
      function(a) {
        a = window.event || a;
        if (!$j("#inputInner").is(":hidden")) if (a.keyCode == 13) { (a = $j("#inputInner .active").text()) && b("input[name=email]").val(a);
          b("input[name=email]").focus();
          $j("#emailerrtip").hide();
          setTimeout(function() {
            $j("#inputInner").hide();
            $j("#selectBox").show()
          },
          200)
        } else if (a.keyCode == 37 || a.keyCode == 38) {
          var d = false,
          e = $j(".preslemail").length;
          $j(".preslemail").each(function(i) {
            var k = $j(".preslemail").eq(e - i - 1);
            if (k.hasClass("active") && i != e - 1) {
              k.removeClass("active");
              return d = true
            } else if (d) {
              k.addClass("active");
              return false
            }
          })
        } else if (a.keyCode == 39 || a.keyCode == 40) {
          d = false;
          e = $j(".preslemail").length;
          $j(".preslemail").each(function(i) {
            if (b(this).hasClass("active") && i != e - 1) {
              b(this).removeClass("active");
              return d = true
            } else if (d) {
              b(this).addClass("active");
              return false
            }
          })
        }
      });
      h[0].onchange = c;
      n[0].onchange = c;
      q[0].onchange = c;
      m.uv = function(a, d) {
        var e = h.val(),
        i = n.val(),
        k = q.val(),
        j = d !== "focus" && d !== "blur";
        if (e && i && k) {
          m.pass(a);
          return true
        } else if (!e && j) m.fail(h, "\u8bf7\u9009\u62e9\u5b8c\u6574\u751f\u65e5\u65e5\u671f", true);
        else if (!i && j) m.fail(n, "\u8bf7\u9009\u62e9\u5b8c\u6574\u751f\u65e5\u65e5\u671f", true);
        else ! k && j && m.fail(q, "\u8bf7\u9009\u62e9\u5b8c\u6574\u751f\u65e5\u65e5\u671f", true);
        return false
      };
      b("#randimg2").bind("captcha:change",
      function(a, d) {
        b("input[name=code]").attr("data-valid-url", "/interface/checkcode.php?keytype=reg&rcode=" + d);
        b("input[name=code]").attr("rcode", d)
      });
      m.serverHandler = function(a, d) {
        d = parseInt(d, 10);
        if (a.name in p) return typeof p[a.name][d] != "undefined" ? p[a.name][d] : typeof p[a.name]["default"] != "undefined" ? p[a.name]["default"] : "\u672a\u77e5\u9519\u8bef:" + d;
        if (a.name == "code") if (d === 0) {
          s.changeRcode2();
          return "\u9a8c\u8bc1\u7801\u8f93\u5165\u6709\u8bef\uff0c\u8bf7\u91cd\u8f93"
        } else if (d == 1) {
          $j(".captchadiv_mobile").show();
          return true
        }
      }
    }
  }
});
