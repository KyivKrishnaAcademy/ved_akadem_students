class CertificateTemplatePolicy < BasePolicy
  def markup?
    edit?
  end

  def finish?
    markup?
  end

  def background?
    markup?
  end
end
