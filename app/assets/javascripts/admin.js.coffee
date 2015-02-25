# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

EditAccountMaxAddressesRow = 6

editAccountAddressesRow = 0

window.regionList = {}
window.workplaceList = {}
window.editAccountAddAddressesRow = (address = "", region = "") ->
  if editAccountAddressesRow < EditAccountMaxAddressesRow
    editAccountAddressesRow++
    tr_addresses = document.getElementById("table_addresses").insertRow(document.getElementById("tr_add_addresses").rowIndex)
    tr_addresses.id = "tr_addresses#{editAccountAddressesRow}"
    td_addresses = tr_addresses.insertCell(0)
    input_addresses = document.createElement("textarea")
    input_addresses.id = "input_addresses#{editAccountAddressesRow}"
    input_addresses.name = "addresses[][address]"
    input_addresses.rows = 3
    input_addresses.cols = 41
    input_addresses.required = true
    input_addresses.value = address
    td_addresses.appendChild(input_addresses)
    input_remove_addresses = document.createElement("input")
    input_remove_addresses.id = "input_remove_addresses#{editAccountAddressesRow}"
    input_remove_addresses.type = "button"
    input_remove_addresses.value = "-"
    input_remove_addresses.setAttribute("onclick", "editAccountRemoveAddressesRow(#{editAccountAddressesRow});")
    td_addresses.appendChild(input_remove_addresses)
    break_link = document.createElement("br")
    td_addresses.appendChild(break_link)
    input_region = document.createElement("select")
    input_region.id = "input_region#{editAccountAddressesRow}"
    input_region.name = "addresses[][region_id]"
    input_region.required = true
    input_region_option = document.createElement("option")
    input_region_option.value = ""
    input_region_option.innerHTML = "--"
    input_region_option.setAttribute("disabled", "")
    input_region_option.setAttribute("selected", "")
    input_region.appendChild(input_region_option)
    for k, v of regionList
      input_region_option = document.createElement("option")
      input_region_option.value = k
      input_region_option.innerHTML = v
      if k is region
        input_region_option.setAttribute("selected", "")
      input_region.appendChild(input_region_option)
    td_addresses.appendChild(input_region)
    document.getElementById("th_addresses").setAttribute("rowspan", "#{editAccountAddressesRow + 2}")
  if editAccountAddressesRow is EditAccountMaxAddressesRow
    document.getElementById("input_add_addresses").setAttribute("disabled", "")
  null
window.editAccountRemoveAddressesRow = (row) ->
  editAccountAddressesRow--
  document.getElementById("table_addresses").deleteRow(document.getElementById("tr_addresses#{row}").rowIndex)
  for t in [row + 1..EditAccountMaxAddressesRow]
    tr_addresses = document.getElementById("tr_addresses#{t}")
    if tr_addresses
      tr_addresses.id = "tr_addresses#{t - 1}"
    else
      break
    input_addresses = document.getElementById("input_addresses#{t}")
    if input_addresses
      input_addresses.id = "input_addresses#{t - 1}"
    else
      break
    input_remove_addresses = document.getElementById("input_remove_addresses#{t}")
    if input_remove_addresses
      input_remove_addresses.id = "input_remove_addresses#{t - 1}"
      input_remove_addresses.setAttribute("onclick", "editAccountRemoveAddressesRow(#{t - 1});")
    else
      break
  if editAccountAddressesRow is 0
    editAccountAddAddressesRow()
  document.getElementById("th_addresses").setAttribute("rowspan", "#{editAccountAddressesRow + 2}")
  document.getElementById("input_add_addresses").removeAttribute("disabled")
  null
window.editAccountOnLoad = (addresses) ->
  editAccountAddressesRow = 0
  if addresses.length is 0
    editAccountAddAddressesRow()
  else
    for x in addresses
      editAccountAddAddressesRow(x["address"], x["region"])
  null
window.editAccountOnSubmit = () ->
  md5Passwrod("input_password2")
  for t in [1..EditAccountMaxAddressesRow]
    addresses = document.getElementById("input_addresses#{t}")
  true
window.editAccountOnChangeWorkplaceType = () ->
  input_workplace_type = document.getElementById("input_workplace_type")
  workplace_type = input_workplace_type.selectedOptions.item(0).textContent
  input_workplace = document.getElementById("input_workplace")
  while (x = input_workplace.firstChild)
    input_workplace.removeChild(x)
  input_workplace_option = document.createElement("option")
  input_workplace_option.value = ""
  input_workplace_option.innerHTML = "--"
  input_workplace_option.setAttribute("disabled", "")
  input_workplace_option.setAttribute("selected", "")
  input_workplace.appendChild(input_workplace_option)
  for k, v of workplaceList[workplace_type]
    input_workplace_option = document.createElement("option")
    input_workplace_option.value = k
    input_workplace_option.innerHTML = k + " - " + v
    input_workplace.appendChild(input_workplace_option)
  null
window.editProfileOnSubmit = () ->
  md5Passwrod("input_password")
  md5Passwrod("input_password2")
  true
window.loginOnSubmit = () ->
  md5Passwrod("input_password")
  true
window.md5Passwrod = (elementId) ->
  element = document.getElementById(elementId)
  if element.value
    element.value = md5(md5(element.value))
  true
window.validatePassword = () ->
  input_password1 = document.getElementById("input_password1")
  input_password2 = document.getElementById("input_password2")
  match = input_password1.value is input_password2.value
  input_password2.setCustomValidity(if match then "" else "Passwords do not match")
  match
