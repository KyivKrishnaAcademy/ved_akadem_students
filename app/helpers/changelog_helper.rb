module ChangelogHelper
  def link_to_commit(commit_hash)
    content_tag(:tt) do
      concat('[')
      concat(link_to(commit_hash[0, 7], "#{Rails.application.secrets.repo_commit_sub_url}#{commit_hash}"))
      concat(']')
    end
  end
end
