ClassScheduleWithPeople.paper_trail.disable if defined?(ClassScheduleWithPeople)

require_dependency 'paper_trail_custom_serializer' if Rails.env.development?
PaperTrail.serializer = PaperTrailCustomSerializer if defined?(PaperTrailCustomSerializer)
PaperTrail.config.track_associations = false if PaperTrail.respond_to?(:track_associations=)
