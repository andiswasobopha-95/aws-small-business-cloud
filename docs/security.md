# Security notes
TODO: what is public vs private, what the backup user can and cannot do, and why.

## Backup user policy
- The backup user can list the backup bucket and upload files to it.
- The policy explicitly denies deleting files or versions.
- An explicit deny wins over any allow, so deletes stay blocked even if a broader permission is added by mistake.
