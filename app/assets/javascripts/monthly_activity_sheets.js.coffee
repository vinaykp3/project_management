# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.employee_project_month_result_list = (path) ->
  month_selected = $('#month_id').val()
  project_selected = $('#project_id').val()
  $('#employee_result_list').load(path+"?month_selected="+month_selected+"&project_selected="+project_selected)

window.employee_project_select_result_list = (path) ->
  project_selected = $('#project_id').val()
  $('#result-list').load(path+"?project_selected="+project_selected)