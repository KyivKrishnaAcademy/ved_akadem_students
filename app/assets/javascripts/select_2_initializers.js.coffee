$ ->
  # Functions

  personOption = (person) ->
    if person.loading
      return person.text

    '<div class="row"><div class="col-sm-1"><img src="' + person.imageUrl + '" />' +
      '</div><div clas="col-sm-10">' + person.text + '</div></div>'

  personSelect = (domObj, jsonRoot) ->
    if domObj.length
      domObj.select2
        ajax:
          dataType: 'json'
          delay: 250
          data: (params) ->
            {
              q: params.term
              page: params.page
            }
          processResults: (data, page) ->
            { results: data[jsonRoot] }
          cache: true
        escapeMarkup: (markup) ->
          markup
        templateResult: (person) ->
          personOption(person)

  # Initializers

  personSelect($('select#academic_group_curator_id'), 'people')
  personSelect($('select#academic_group_praepostor_id'), 'people')
  personSelect($('select#academic_group_administrator_id'), 'people')

  personSelect($('select#course_teacher_profile_ids'), 'teacher_profiles')
