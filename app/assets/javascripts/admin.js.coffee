# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

loginOnSubmit = () ->
  input_password = document.getElementById("input_password");
  input_password.value = md5(md5(input_password.value));
  return true;

window.loginOnSubmit = loginOnSubmit;
