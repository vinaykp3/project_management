# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.employee_result_list = (path) ->
  selected = $('#project_employee_project_id').val();
  $('#employee_result_list').load(path+"?selected="+selected)