# Console guide (my build log)

For each step, write what you did, what confused you, and add a screenshot to `docs/screenshots/`.
This file is part of the project: it shows how you work.

## Setup
- [ ] Root MFA enabled. TODO: notes
- [ ] IAM admin user created. TODO: notes
- [ ] AWS CLI configured. TODO: notes

## Part A: Website
Hints:
- S3 -> Create bucket. Keep "Block all public access" ON. Bucket names must be globally unique.
- Upload `site/index.html`, `error.html`, `style.css`.
- CloudFront -> Create distribution. Origin = your S3 bucket. Choose Origin access control (create a new one).
- Set Default root object to `index.html`. Set viewer protocol policy to redirect HTTP to HTTPS.
- CloudFront shows a bucket policy to copy; paste it into the bucket's Permissions -> Bucket policy.
- Open the distribution domain name (ends in cloudfront.net). New distributions take a few minutes to deploy.

TODO: your notes and screenshots

## Part B: Backups
Hints:
- Create a second bucket. Block public access ON. Turn Bucket Versioning ON. Default encryption should be on.
- Management -> Lifecycle rules: move objects to a cheaper storage class after a number of days you choose, and decide what happens to old versions.
- IAM -> Create policy (JSON): allow `s3:PutObject` and `s3:ListBucket` on the backup bucket only. No delete actions.
- IAM -> Create user, attach that policy, create an access key.
- Save the backup user's keys as a separate CLI profile: `aws configure --profile backup`.
- Test: `aws s3 sync sample-data/ s3://YOUR-BACKUP-BUCKET --profile backup`

TODO: your notes and screenshots

## Part C: Safety net
Hints:
- Billing and Cost Management -> Budgets -> Create budget -> Cost budget.
- Set a small monthly amount and an email alert at around 80%.

TODO: your notes and screenshots

## Cleanup checklist
- [ ] Empty both S3 buckets (including old versions), then delete them
- [ ] Disable, then delete, the CloudFront distribution
- [ ] Delete the backup IAM user and its access keys
- [ ] Delete the budget
- [ ] Check the console for anything left behind
- [ ] On a shared computer: remove saved AWS credentials (`rm -rf ~/.aws`)
