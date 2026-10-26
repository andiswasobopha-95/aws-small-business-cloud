# Build order

Details for each step are in `docs/console-guide.md`.

## Setup
- [x] 1. AWS account safety: MFA, and a check that I'm on the Free plan with credits
- [x] 2. Used the console and CloudShell instead of installing the AWS CLI on the shared school computer

## Part A: Website
- [x] 3. Wrote a simple page in `site/`
- [x] 4. Created a private S3 bucket for the website and uploaded the files
- [x] 5. Created a CloudFront distribution pointing at the bucket (origin access control)
- [x] 6. Confirmed the bucket policy and opened the CloudFront URL

## Part B: Backups
- [x] 7. Created a second S3 bucket for backups (block public access, versioning on)
- [x] 8. Added a lifecycle rule for older backups
- [x] 9. Created an IAM user that can upload but NOT delete
- [x] 10. Tested versioning by uploading a changed test file twice
- [x] 11. Checked that both versions are kept

## Part C: Safety net
- [x] 12. Created an AWS Budget with email alerts

## Finish
- [x] 13. Filled in `docs/`, screenshots and the README
- [ ] 14. Clean up and check the console for leftovers (when I close the Free plan account)
