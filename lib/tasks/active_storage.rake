namespace :active_storage do
  desc 'ActiveStorage::Attachmentと紐づいていないActiveStorage::Blobの画像を削除'
  task purge_unattached: :environment do
    ActiveStorage::Blob.unattached.find_each(&:purge)
  end
end
