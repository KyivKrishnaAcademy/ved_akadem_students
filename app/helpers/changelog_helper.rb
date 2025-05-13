module ChangelogHelper
  def link_to_commit(commit_hash)
    return content_tag(:tt, '[нет хеша]') if commit_hash.blank?
  
    content_tag(:tt) do
      concat('[')
      concat(link_to(commit_hash[0, 7], "#{ENV["REPO_COMMIT_SUB_URL"]}#{commit_hash}"))
      concat(']')
    end
  end
end
