# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

EditAccountMaxAddressesRow = 6

editAccountAddressesRow = 0

window.buildingList = {}
window.regionList = {}
window.staffStoreList = {}
window.workplaceList = {}
window.dayChange = (changedDayIndex) ->
  input_day = document.getElementById("input_day")
  input_day.value = parseInt(input_day.value) ^ (1 << changedDayIndex)
  day = document.getElementById("day" + changedDayIndex)
  if (input_day.value >>> changedDayIndex) % 2 is 1
    day.style.color = "green"
    day.style.fontWeight = "bold"
  else
    day.style.color = "lightgrey"
    day.style.fontWeight = ""
  null
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
    input_addresses.setAttribute("oninput", "validateAddresses();")
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
    input_region.setAttribute("onchange", "validateAddresses();")
    input_region_option = document.createElement("option")
    input_region_option.value = ""
    input_region_option.innerHTML = "--"
    input_region_option.setAttribute("disabled", "")
    input_region.appendChild(input_region_option)
    for k, v of regionList
      input_region_option = document.createElement("option")
      input_region_option.value = k
      input_region_option.innerHTML = v
      input_region_option.setAttribute("selected", "") if k is region
      input_region.appendChild(input_region_option)
    td_addresses.appendChild(input_region)
    document.getElementById("th_addresses").setAttribute("rowspan", "#{editAccountAddressesRow + 2}")
  document.getElementById("input_add_addresses").setAttribute("disabled", "") if editAccountAddressesRow is EditAccountMaxAddressesRow
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
  input_workplace_id = document.getElementById("input_workplace_id")
  while x = input_workplace_id.firstChild
    input_workplace_id.removeChild(x)
  input_workplace_option = document.createElement("option")
  input_workplace_option.value = ""
  input_workplace_option.innerHTML = "--"
  input_workplace_option.setAttribute("disabled", "")
  input_workplace_id.appendChild(input_workplace_option)
  for k, v of workplaceList[workplace_type]
    input_workplace_option = document.createElement("option")
    input_workplace_option.value = k
    input_workplace_option.innerHTML = k + " - " + v
    input_workplace_id.appendChild(input_workplace_option)
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
window.editInspectTaskPlanOnChangeStaff = () ->
  input_staff = document.getElementById("input_staff")
  staff_id = input_staff.selectedOptions.item(0).value
  input_store_option_default = document.getElementById("input_store_option_default")
  if store = staffStoreList[staff_id]
    input_store_option_default.value = store.id
    input_store_option_default.textContent = store.id + " - " + store.name + " (workplace)"
    input_store_option_default.removeAttribute("disabled")
  else
    input_store_option_default.value = ""
    input_store_option_default.textContent = "--"
    input_store_option_default.setAttribute("disabled", "")
  null
window.editProfileOnSubmit = () ->
  md5Passwrod("input_password")
  md5Passwrod("input_password2")
  true
window.editTransferTaskPlanOnChangeFromType = () ->
  input_from_type = document.getElementById("input_from_type")
  from_type = input_from_type.selectedOptions.item(0).textContent
  input_from_id = document.getElementById("input_from_id")
  while x = input_from_id.firstChild
    input_from_id.removeChild(x)
  input_from_option = document.createElement("option")
  input_from_option.value = ""
  input_from_option.innerHTML = "--"
  input_from_option.setAttribute("disabled", "")
  input_from_id.appendChild(input_from_option)
  for k, v of buildingList[from_type]
    input_from_option = document.createElement("option")
    input_from_option.value = k
    input_from_option.innerHTML = k + " - " + v
    input_from_id.appendChild(input_from_option)
  null
window.editTransferTaskPlanOnChangeToType = () ->
  input_to_type = document.getElementById("input_to_type")
  to_type = input_to_type.selectedOptions.item(0).textContent
  input_to_id = document.getElementById("input_to_id")
  while x = input_to_id.firstChild
    input_to_id.removeChild(x)
  input_to_option = document.createElement("option")
  input_to_option.value = ""
  input_to_option.innerHTML = "--"
  input_to_option.setAttribute("disabled", "")
  input_to_id.appendChild(input_to_option)
  for k, v of buildingList[to_type]
    input_to_option = document.createElement("option")
    input_to_option.value = k
    input_to_option.innerHTML = k + " - " + v
    input_to_id.appendChild(input_to_option)
  null
window.editVisitTaskPlanOnChangeHandleOrder = () ->
  document.getElementById("input_send_number").max = document.getElementById("input_send_receive_number").value
  null
window.loginOnSubmit = () ->
  md5Passwrod("input_password")
  true
window.md5Passwrod = (elementId) ->
  element = document.getElementById(elementId)
  element.value = md5(md5(element.value)) if element.value
  true
window.validateAddresses = () ->
  result = true
  addresses = []
  input_addresses = []
  for t1 in [0...editAccountAddressesRow]
    input_addresses[t1] = document.getElementById("input_addresses#{t1 + 1}")
    input_addresses[t1].setCustomValidity("")
    addresses[t1] = input_addresses[t1].value + document.getElementById("input_region#{t1 + 1}").selectedOptions.item(0).value
    for t2 in [0...t1]
      if addresses[t1] is addresses[t2]
        result = false
        input_addresses[t1].setCustomValidity("Address repeated")
  result
window.validatePassword = () ->
  input_password1 = document.getElementById("input_password1")
  input_password2 = document.getElementById("input_password2")
  result = input_password1.value is input_password2.value
  input_password2.setCustomValidity(if result then "" else "Passwords do not match")
  result
window.validateTransferbuilding = () ->
  input_to_id = document.getElementById("input_to_id")
  result = document.getElementById("input_from_type").value isnt document.getElementById("input_to_type").value or document.getElementById("input_from_id").value isnt input_to_id.value
  input_to_id.setCustomValidity(if result then "" else "Can not transfer to the same location")
  result
