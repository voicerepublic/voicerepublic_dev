AWS.config(access_key_id:     Settings.fog.storage.aws_access_key_id,
           secret_access_key: Settings.fog.storage.aws_secret_access_key)

S3_TALK_UPLOAD_BUCKET = AWS::S3.new.buckets[Settings.talk_upload_bucket]
