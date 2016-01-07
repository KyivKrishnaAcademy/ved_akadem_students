createCertificate = (data) ->
  $.ajax
    url: '/ui/certificates'
    type: 'POST',
    data: data,
    dataType: 'json'
  .done (resolved) ->
    console.log('resolved', resolved) # DEBUG

$ ->
  cert_assign = $('.cert_assign')

  cert_assign. on 'click', '.btn-submit', (e) ->
    button = e.target.closest 'button'

    button.classList.add 'active'

    data = certificate:
      assigned_cert_template_id: button.getAttribute('data-assigned-template')
      student_profile_id: button.getAttribute('data-profile')

    console.log('data', data) # DEBUG

    createCertificate(data).always () ->
      button.classList.remove 'active'
