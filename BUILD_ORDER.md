# Build order (tick as you go)

Details for each step are in `docs/console-guide.md`. Write down what you did and take a screenshot as you go.

## Setup
- [ ] 1. AWS account safety: MFA on root, an IAM admin user for daily use (not root)
- [ ] 2. Install the AWS CLI; run `aws configure`; check with `aws sts get-caller-identity`

## Part A: Website
- [ ] 3. Write a simple page in `site/`
- [ ] 4. Create a private S3 bucket for the website and upload the files
- [ ] 5. Create a CloudFront distribution pointing at the bucket (with Origin Access Control)
- [ ] 6. Apply the bucket policy CloudFront gives you; open the CloudFront URL

## Part B: Backups
- [ ] 7. Create a second S3 bucket for backups (block public access, versioning on)
- [ ] 8. Add a lifecycle rule for older backups
- [ ] 9. Create an IAM user that can upload but NOT delete
- [ ] 10. Write `scripts/backup.sh`, test it with FAKE files in `sample-data/`
- [ ] 11. Overwrite a file and practise restoring the old version

## Part C: Safety net
- [ ] 12. Create an AWS Budget with an email alert

## Finish
- [ ] 13. Fill in `docs/`, screenshots and the README TODOs
- [ ] 14. Clean up and check the console for leftovers

Tip: finish Part A completely before Part B. Part A alone is already a demo-able project.
