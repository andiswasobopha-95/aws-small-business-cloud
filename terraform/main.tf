# TODO: build in this order (see BUILD_ORDER.md):
#
# --- Part A: Website ---
#   1. provider "aws" with your region
#   2. website bucket (private) + public access block
#   3. CloudFront origin access control + distribution (default root object index.html, redirect HTTP to HTTPS)
#   4. website bucket policy that only allows your CloudFront distribution to read
#
# --- Part B: Backups ---
#   5. backup bucket + public access block + encryption + versioning
#   6. lifecycle configuration (move older versions/objects to cheaper storage; you choose the number of days)
#   7. IAM user + policy: allow PutObject and ListBucket on the backup bucket ONLY; no delete permissions
#
# --- Part C: Safety net ---
#   8. SNS topic + email subscription
#   9. CloudWatch billing alarm
#      GOTCHA: billing metrics only exist in us-east-1, so this alarm needs a second provider
#      configured for us-east-1 (an "alias" provider). Look this up when you reach it.
