$ ->
  courseTeacherProfiles = $('select#course_teacher_profile_ids')

  if courseTeacherProfiles.length
    courseTeacherProfiles.select2
      ajax:
        url: '/ui/teacher_profiles',
        dataType: 'json'
        delay: 250
        data: (params) ->
          {
            q: params.term
            page: params.page
          }
        processResults: (data, page) ->
          { results: data.teacher_profiles }
        cache: true
      escapeMarkup: (markup) ->
        markup
      templateResult: (teacher) ->
        if teacher.loading
          return teacher.text

        '<div class="row"><div class="col-sm-1"><img src="' + teacher.imageUrl + '" />' +
          '</div><div clas="col-sm-10">' + teacher.text + '</div></div>'
