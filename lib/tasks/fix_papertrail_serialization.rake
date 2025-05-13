namespace :academic do
  desc 'Fixes serialized objects by removing CarrierWave uploaders'
  task fix_papertrail_serialization: :environment do
    progress_element = '.'.freeze
    affected_versions = PaperTrail::Version.where('object ILIKE ?', '%uploader%')

    puts "\nFixing #{affected_versions.count} versions\n"

    affected_versions.each do |version|
      version.object = ::RemoveUploadersFromModelYamlDumpService.call(version.object)

      version.save

      print progress_element
    end

    puts "\nDone.\n"
  end
end
