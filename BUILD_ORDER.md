# Build order (tick as you go)

## Setup
- [ ] 1. AWS account safety: MFA on root, an IAM admin user for daily use (not root)
- [ ] 2. Enable billing alerts in the AWS account settings
- [ ] 3. Install the AWS CLI and Terraform; run `aws configure`; check with `aws sts get-caller-identity`

## Part A: Website
- [ ] 4. Write a simple page in `site/`
- [ ] 5. Terraform: private website bucket + public access block
- [ ] 6. Terraform: CloudFront distribution with Origin Access Control
- [ ] 7. Terraform: bucket policy so only CloudFront can read the bucket
- [ ] 8. `terraform apply`, upload the site, open the CloudFront URL

## Part B: Backups
- [ ] 9. Terraform: backup bucket (public access block, encryption, versioning)
- [ ] 10. Terraform: lifecycle rule for older backups
- [ ] 11. Terraform: IAM user/policy that can upload but NOT delete
- [ ] 12. Write `scripts/backup.sh` and test it with FAKE files in `sample-data/`
- [ ] 13. Overwrite a file and practise restoring the old version (write `docs/restore-guide.md`)

## Part C: Safety net
- [ ] 14. Terraform: SNS topic + email subscription (confirm the email!)
- [ ] 15. Terraform: billing alarm

## Finish
- [ ] 16. Fill in `docs/`, screenshots and the README TODOs
- [ ] 17. Run the teardown script and check the AWS console for leftovers

Tip: do Part A completely before starting Part B. A finished Part A alone is already a demo-able project.
