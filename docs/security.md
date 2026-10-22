# Security notes

## What is public and what is private
- **Public:** the website, only through the CloudFront address (HTTPS).
- **Private:** both S3 buckets. "Block all public access" is on for each one.
- The website bucket can only be read by my CloudFront distribution. CloudFront added a bucket policy for this when I used the "allow private S3 bucket access" option.

## Backup user
- IAM user `bakery-backup-user` has **no console access** and only one policy, `bakery-backup-upload-only`.
- The policy allows: listing the backup bucket and uploading objects.
- The policy **explicitly denies** deleting objects and object versions. An explicit deny overrides any allow, so deletes stay blocked even if a broader permission is added by mistake.
- Reason: if the computer using these credentials is lost or stolen, an attacker can add files but cannot remove backups.
- The backup bucket also has versioning on, so an overwritten file keeps its older versions.

## Accounts and credentials
- MFA is registered on my AWS sign-in.
- Credentials were never stored on the shared school computer. I used the browser console.
- I created an access key for the backup user, then deleted it after it was accidentally exposed in a chat. The saved local credentials were removed too.
- No keys, secrets or tokens are stored in this repository. `.gitignore` excludes `.env` and key files, and screenshots were cropped or chosen so they don't show my account number.

## Choices I made on purpose
- I did **not** enable the web application firewall (WAF) on CloudFront. The wizard estimated about $14 per 10 million requests per month, and a static page with no logins or forms doesn't need it.
- I did not turn on Origin Shield, a paid extra.

## Known gaps / next steps
- No access logging or CloudTrail review yet.
- No bucket policy that refuses non-HTTPS requests to the buckets.
- No MFA Delete on the backup bucket's versioning.
- The Free plan account closes after at most 6 months, so this setup is for learning, not for a real business.
