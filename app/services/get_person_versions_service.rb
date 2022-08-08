class GetPersonVersionsService
  def self.call(person)
    student_profile = person.student_profile

    versions = base_relation(person)
    versions = mix_student_profilable(versions, student_profile)
    versions = mix_student_application(versions, person)
    versions = mix_telephones(versions, person)
    versions = mix_answers(versions, person)
    versions = mix_group_participations(versions, student_profile)
    versions = mix_attendances(versions, student_profile)
    versions = mix_notes(versions, person)
    versions = mix_examination_results(versions, student_profile)
    versions = mix_certificates(versions, student_profile)
    versions = mix_missing_creates(versions)

    versions.distinct.order(created_at: :desc)
  end

  private_class_method def self.base_relation(person)
    PaperTrail::Version
      .where(item_type: 'Person', item_id: person.id)
      .or(PaperTrail::Version.where_object(person_id: person.id))
  end

  private_class_method def self.mix_student_profilable(relation, student_profile)
    if student_profile.present?
      relation.or(PaperTrail::Version.where_object(student_profile_id: student_profile.id))
    else
      relation
    end
  end

  private_class_method def self.mix_relation(relation, model_name, ids)
    if ids&.any?
      relation.or(PaperTrail::Version.where(item_type: model_name, item_id: ids))
    else
      relation
    end
  end

  private_class_method def self.mix_student_application(relation, person)
    mix_relation(relation, 'StudyApplication', Array(person.study_application&.id))
  end

  private_class_method def self.mix_telephones(relation, person)
    mix_relation(relation, 'Telephone', Array(person.telephone_ids))
  end

  private_class_method def self.mix_answers(relation, person)
    mix_relation(relation, 'Answer', Array(person.answer_ids))
  end

  private_class_method def self.mix_group_participations(relation, student_profile)
    mix_relation(relation, 'GroupParticipation', Array(student_profile&.group_participation_ids))
  end

  private_class_method def self.mix_attendances(relation, student_profile)
    mix_relation(relation, 'Attendance', Array(student_profile&.attendance_ids))
  end

  private_class_method def self.mix_notes(relation, person)
    mix_relation(relation, 'Note', person.note_ids)
  end

  private_class_method def self.mix_examination_results(relation, student_profile)
    mix_relation(relation, 'ExaminationResult', Array(student_profile&.examination_result_ids))
  end

  private_class_method def self.mix_certificates(relation, student_profile)
    mix_relation(relation, 'Certificate', Array(student_profile&.certificate_ids))
  end

  private_class_method def self.mix_missing_creates(relation)
    updates = relation.where.not(event: 'create').pluck('distinct item_type, item_id')

    if updates.empty?
      relation
    else
      updates.inject(relation) do |acc_relation, (item_type, item_id)|
        acc_relation.or(PaperTrail::Version.where(item_type: item_type, item_id: item_id))
      end
    end
  end
end
