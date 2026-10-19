# Cloud Setup for a Small Business on AWS

A beginner-friendly cloud project that solves three real problems a small business has: **having a website, not losing its data, and not getting a surprise cloud bill.** It is built on AWS using the AWS Management Console and the AWS CLI.

> **Scenario:** This is a fictional case study based on a common real-life situation. A small local business (think a bakery, hair salon or tutoring service) has a basic website, keeps its orders, price lists and customer bookings on one office computer, and has no backup. When the computer fails or is stolen, or is damaged during load shedding, the business loses everything.

---

## 1. Project overview

### The problem

| Problem | Real-life consequence |
|---------|-----------------------|
| No reliable website | Customers can't find opening hours, prices or contact details |
| No backups | One hard-drive failure or theft means lost orders and customer records |
| No cost visibility | A cloud mistake can quietly produce a large bill |

### The solution
A small, low-cost AWS setup with three parts:

1. **Website hosting:** the website is stored in a private S3 bucket and delivered fast and securely over HTTPS through CloudFront.
2. **Backups:** a separate, encrypted S3 bucket with versioning (so overwritten or deleted files can be recovered) and a lifecycle rule that moves older backups to cheaper storage.
3. **Safety net:** a budget alert that emails the owner if spending goes above a set amount, plus a least-privilege IAM user that can only upload backups, not delete them.

### Who it's for
A non-technical owner who needs something reliable and cheap, and a developer (me) who needs to build it and document it clearly.

---

## 2. Architecture

```
                     +--------------------+
   Visitor --HTTPS-->|    CloudFront      |
                     |   (CDN + HTTPS)    |
                     +---------+----------+
                               | (only CloudFront may read)
                     +---------v----------+
                     |  S3: website       |   private bucket
                     +--------------------+

   Office computer --(aws s3 sync, backup user)--> +--------------------+
                                                   |  S3: backups       |
                                                   |  versioning        |
                                                   |  encryption        |
                                                   |  lifecycle rule    |
                                                   +--------------------+

   AWS Budgets --> email alert to the owner
```

TODO: replace this with a proper diagram image (draw.io or Excalidraw) saved as `docs/architecture.png`.

### AWS services used

| Service | Role in the project |
|---------|--------------------|
| S3 (website bucket) | Stores the website files, kept private |
| CloudFront | Serves the site over HTTPS and caches it close to visitors |
| S3 (backup bucket) | Stores backups with versioning and encryption |
| IAM | A backup-only user with minimum permissions |
| AWS Budgets | Emails the owner if spending passes a limit |

---

## 3. Key design decisions

Full notes go in `docs/decisions.md`.

- **Private buckets, CloudFront in front.** Nobody can read the website bucket directly, which reduces the risk of accidental public exposure.
- **Versioning on the backup bucket.** If a file is overwritten or deleted by mistake, an older version can be restored.
- **Lifecycle rule.** Old backups move to cheaper storage so costs stay low as data grows.
- **Least-privilege IAM.** The backup user can upload but cannot delete, so a stolen laptop can't wipe the backups.
- **Built through the console first.** I built this with the AWS console and CLI to learn how each service works before automating anything. Infrastructure as code (Terraform) is listed under future improvements.

---

## 4. Security

- Both buckets block all public access.
- The backup bucket is encrypted at rest.
- Credentials are never stored in the repo (`.gitignore` excludes `.env` and key files).
- MFA is enabled on the AWS root account, which is not used day to day.

TODO: add anything else you implement, such as a bucket policy that requires HTTPS.

---

## 5. Cost

This design is meant to cost very little at small-business scale, mostly storage and a few requests. The budget alert is the safeguard in case that changes.

TODO: after building, add your real numbers here and link an AWS Pricing Calculator estimate (see `docs/cost-estimate.md`).

---

## 6. Repository structure

```
aws-small-business-cloud/
├── README.md              <- you are here
├── BUILD_ORDER.md         <- step-by-step build checklist
├── site/                  <- the website files
├── sample-data/           <- FAKE files to test backups (never real data)
├── scripts/               <- deploy and backup helper scripts
└── docs/                  <- console guide, decisions, security, cost, restore guide, screenshots
```

---

## 7. How it was built

The step-by-step record of what I clicked and ran is in [`docs/console-guide.md`](docs/console-guide.md), with screenshots in `docs/screenshots/`.

### Proving it works
- [ ] Website loads over HTTPS from the CloudFront URL
- [ ] A backup file uploads, and I can see it in the backup bucket
- [ ] I overwrite a file, then restore the older version (see `docs/restore-guide.md`)
- [ ] The budget alert email subscription is confirmed

---

## 8. Cleanup

Cloud resources can cost money if left running. When finished, follow the cleanup list at the end of `docs/console-guide.md` (empty the buckets, delete the CloudFront distribution, delete the IAM user and budget).

---

## 9. Future improvements

- Rebuild the whole setup with Terraform (infrastructure as code) so it can be recreated in minutes
- Custom domain with Route 53 and a free HTTPS certificate (ACM)
- Scheduled automatic backups
- Copy backups to a second AWS region for disaster recovery
- Auto-deploy the website with GitHub Actions

---

## 10. What I learned

TODO: write 4-5 honest sentences in your own words, covering what was hard, what surprised you, and what you'd do differently.
VERIFICATION CODE-
WTC-C75CTTTF
