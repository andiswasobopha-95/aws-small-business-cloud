# Architecture notes

## Website path
Visitor -> CloudFront (HTTPS, cached copies) -> private S3 bucket `andiswa-bakery-site-2026`

- CloudFront is the only thing allowed to read the bucket.
- Visitors opening the bare address get `index.html` (the default root object).

## Backup path
Authorised user -> S3 bucket `andiswa-bakery-backups-2026`

- Versioning is on, so overwritten or deleted files keep older versions.
- A lifecycle rule moves current files to Standard-IA after 30 days, deletes noncurrent versions after 90 days and cleans up incomplete uploads after 7 days.
- The backup user (`bakery-backup-user`) can only list and upload.

## Safety net
AWS Budgets (`bakery-monthly-budget`, $5) -> email alerts

## Failure scenarios I thought about
- Office computer lost or broken: files are in the backup bucket.
- File overwritten by mistake: restore an older version (see `restore-guide.md`).
- Backup key stolen: it can add files but cannot delete any.
- Unexpected cost: the budget emails me early.
