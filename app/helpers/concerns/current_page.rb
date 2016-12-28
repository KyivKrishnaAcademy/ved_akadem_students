module CurrentPage
  # Allow the helper to accept "enforce_params" option
  def current_page?(uri, options = {})
    unless request
      raise "You cannot use helpers that need to determine the current "                  "page unless your view context provides a Request object "                  "in a #request method"
    end

    return false unless request.get? || request.head?

    url_string = URI.parser.unescape(url_for(uri)).force_encoding(Encoding::BINARY)

    # We ignore any extra parameters in the request_uri if the
    # submitted url doesn't have any either. This lets the function
    # work with things like ?order=asc
    request_uri = url_string.index("?") || options[:enforce_params] ? request.fullpath : request.path
    request_uri = URI.parser.unescape(request_uri).force_encoding(Encoding::BINARY)

    url_string.chomp!("/") if url_string.start_with?("/") && url_string != "/"

    if url_string =~ /^\w+:\/\//
      url_string == "#{request.protocol}#{request.host_with_port}#{request_uri}"
    else
      url_string == request_uri
    end
  end
end
