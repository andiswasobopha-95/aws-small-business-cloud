# Decision log

## 21 October 2026: Build in the console, not with Terraform
I first planned Terraform, but learning it at the same time as S3, CloudFront and IAM was too much. I built everything by hand in the console to understand each service first. Terraform is a future improvement.

## 21 October 2026: Keep both buckets private
The website bucket is read only by CloudFront (origin access control), and the backup bucket is never public. This avoids accidental public exposure.

## 21 October 2026: Skip the web application firewall
The wizard estimated about $14 per 10 million requests per month. A static page with no forms or logins doesn't need it, and the cost would eat into the Free plan credits.

## 21 October 2026: Versioning and a 90-day recovery window
Versioning on the backup bucket keeps older copies. Noncurrent versions are deleted after 90 days, so storage doesn't grow forever.

## 21 October 2026: Move older backups to Standard-IA after 30 days
This lowers storage cost as backups age. S3 doesn't transition objects under 128 KB by default, so my small test files will not actually move. (Update this entry if the number of days in the rule is different.)

## 21 October 2026: Explicit deny for deletes on the backup user
The backup user can upload and list but not delete. A stolen laptop or key can't wipe the backups.

## 21 October 2026: No long-lived keys on the shared computer
I used the browser console and CloudShell, not `aws configure` on the school computer. The access key I created for the backup user was deleted after it was exposed.

## 22 October 2026: Monthly cost budget instead of a zero-spend budget
The zero-spend template alerts at $0.01, which would be noisy. A $5 monthly budget alerts at 85% and 100% of spend and on forecasted overspend.
