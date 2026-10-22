# Console guide (my build log)

I built this project by hand in the AWS console, one part at a time, and wrote down what I chose and why.
Region for the S3 buckets: Europe (Stockholm) `eu-north-1`. CloudFront and IAM are global services.

## Setup
- Created an AWS Free plan account (credits instead of charges; the account closes after 6 months or when credits run out).
- Registered MFA with an authenticator app.
- Checked the Free Tier page to confirm I was on the Free plan with my credits.


## Part A: Website

**What I did**
1. Wrote a small bakery page (`index.html`, `error.html`, `style.css`) in `site/`.
2. Created a private S3 bucket, `andiswa-bakery-site-2026`, with "Block all public access" on, ACLs disabled and versioning off.
3. Uploaded the three files to the top level of the bucket.
4. Created a CloudFront distribution (`sunrise-bakery-site`) with the S3 bucket as its origin, using the recommended option that lets CloudFront read the private bucket (origin access control). CloudFront updated the bucket policy for me.
5. Left the recommended origin and cache settings as they were.
6. Chose not to enable the web application firewall (WAF). The wizard estimated about $14 per 10 million requests per month, which a practice site doesn't need.
7. Set the default root object to `index.html` after the distribution was created, because the wizard didn't ask for it.
8. Opened the CloudFront address and checked the site and the error page over HTTPS.

**Proof:** `screenshots/part-a-website-live.png`, `screenshots/part-a-error-page.png`


## Part B: Backups

**What I did**
1. Created a second private bucket, `andiswa-bakery-backups-2026`, with "Block all public access" on and **versioning enabled**.
2. Created a lifecycle rule, `manage-old-backups`, for the whole bucket:
   - move current versions to Standard-IA to Standard-IA after 30 days
   - permanently delete older (noncurrent) versions after 90 days
   - delete incomplete multipart uploads after 7 days
3. Created an IAM policy, `bakery-backup-upload-only`:
   - allows listing the backup bucket
   - allows uploading objects (PutObject)
   - **explicitly denies** DeleteObject and DeleteObjectVersion
4. Created an IAM user, `bakery-backup-user`, with no console access and only that policy attached.
5. Created an access key for it, then **deleted the key** after it was accidentally exposed (see "Mistakes and lessons" below).
6. Tested versioning: uploaded `test-order.txt` twice with different content, and the bucket kept both versions (24 B and 34 B).

**What I did not do:** I did not run a live delete test with the backup user's key. I checked the policy in the IAM console, where it shows an explicit deny on write actions for this bucket.

**Notes on behaviour:** S3 doesn't move objects smaller than 128 KB between storage classes by default, so my small test files would not actually transition.

**Proof:** `screenshots/part-b-lifecycle-rule.png`, `screenshots/part-b-policy-permissions.png`, `screenshots/part-b-versions.png`


## Part C: Safety net

**What I did**
1. Created a monthly cost budget, `bakery-monthly-budget`, set to $5.
2. The template emails me when actual spend reaches 85%, when actual spend reaches 100%, and when forecasted spend is expected to reach 100%.
3. The Budgets page says budgets don't set hard spend limits. This is an alert, not a cap.

**Proof:** `screenshots/part-c-budget.png`


## Mistakes and lessons

- I pasted a live access key into a chat while asking for help. I deleted the key in IAM straight away, removed the saved credentials from the shared computer, and now keep keys out of chats, files and screenshots. The upload-only policy would have limited the damage anyway, since it can't delete anything.
- I first tried Terraform, found it too much to learn at the same time as the AWS services, and rebuilt the project through the console. I'd like to automate it with Terraform later, now that I know what each piece does.
- My IAM policy description was rejected because it contained characters IAM doesn't allow. I shortened it to plain words.
- Screenshots of the AWS console show my account number in the address bar, so I cropped them or used ones without it before publishing.

## Cleanup checklist
- [ ] Empty both S3 buckets (including old versions), then delete them
- [ ] Disable, then delete, the CloudFront distribution
- [ ] Delete the backup IAM user and the policy
- [ ] Delete the budget
- [ ] Check the console for anything left behind
- [ ] On a shared computer: remove saved AWS credentials (`rm -rf ~/.aws`)
