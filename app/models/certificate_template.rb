class CertificateTemplate < ActiveRecord::Base
  FIELDS        = %i(holder id date)
  DIMENSIONS    = %i(x y w h)
  ARRAY_FIELDS  = %i(teachers)

  serialize :fields, HashSerializer

  enum status: %i(draft ready)
end
