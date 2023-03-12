# Functions

personOption = (person) ->
  if person.loading
    return person.text

  '<div class="row">' +
    '<div class="col-sm-1">' +
      '<img src="' + person.imageUrl + '" />' +
    '</div>' +
    '<div clas="col-sm-10">' + person.text + '</div>' +
  '</div>'

personSelect = (domObj, jsonRoot) ->
  if domObj.length
    domObj.select2
      theme: 'bootstrap'
      ajax:
        dataType: 'json'
        delay: 250
        data: (params) ->
          {
            q: params.term
            page: params.page
          }
        processResults: (data, page) ->
          {
            results: data[jsonRoot],
            pagination: {
              more: data.more
            }
          }
        cache: true
      escapeMarkup: (markup) ->
        markup
      templateResult: (person) ->
        personOption(person)

simpleSelect = (domObj, jsonRoot) ->
  if domObj.length
    domObj.select2
      theme: 'bootstrap'
      ajax:
        dataType: 'json'
        delay: 250
        data: (params) ->
          {
            q: params.term
            page: params.page
          }
        processResults: (data, page) ->
          {
            results: data[jsonRoot],
            pagination: {
              more: data.more
            }
          }
        cache: true

$ ->
  # Initializers

  personSelect($('select#academic_group_curator_id'), 'people')
  personSelect($('select#academic_group_praepostor_id'), 'people')
  personSelect($('select#academic_group_administrator_id'), 'people')
  personSelect($('select#program_manager_id'), 'people')

  personSelect($('select#course_teacher_profile_ids'), 'teacher_profiles')
  personSelect($('select#class_schedule_teacher_profile_id'), 'teacher_profiles')

  simpleSelect($('select#class_schedule_academic_group_ids'), 'academic_groups')
  simpleSelect($('select#class_schedule_classroom_id'), 'classrooms')
  simpleSelect($('select#class_schedule_course_id'), 'courses')
  simpleSelect($('select#academic_group_course_ids'), 'courses')
  simpleSelect($('select#program_questionnaire_ids'), 'questionnaires')
