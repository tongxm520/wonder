// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

trim = function(str){
  return str.replace(/(^\s*)|(\s*$)/g,'');
}

ltrim = function(str){
  return str.replace(/(^\s*)/g,'');
}

rtrim = function(str){
  return str.replace(/(\s*$)/g,'');
}


