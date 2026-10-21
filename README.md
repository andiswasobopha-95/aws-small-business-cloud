# Cloud Setup for a Small Business on AWS

A beginner-friendly cloud project that solves three real problems a small business has: **having a website, not losing its data, and not getting a surprise cloud bill.** Everything is built on AWS and defined as code with Terraform.

> **Scenario:** This is a fictional case study based on a common real-life situation. A small local business (think a bakery, hair salon or tutoring service) has a basic website, keeps its orders, price lists and customer bookings on one office computer, and has no backup. When the computer fails or is stolen, or during load shedding damage, the business loses everything.

---

## 1. Project overview

### The problem
Small businesses often run into the same three issues:

| Problem | Real-life consequence |
|---------|-----------------------|
| No reliable website | Customers can't find opening hours, prices or contact details |
| No backups | One hard-drive failure or theft means lost orders and customer records |
| No cost visibility | A cloud mistake can quietly produce a large bill |

### The solution
A small, low-cost AWS setup with three parts:

1. **Website hosting:** the business website is stored in a private S3 bucket and delivered fast and securely over HTTPS through CloudFront.
2. **Automated-style backups:** a separate, encrypted S3 bucket with versioning (so overwritten or deleted files can be recovered) and lifecycle rules that move older backups to cheaper storage.
3. **Safety net:** a billing alarm that emails the owner if spending goes above a set amount, plus a least-privilege IAM user that can only upload backups, not delete them.

### Who it's for
A non-technical owner who needs something reliable and cheap, and a developer (me) who needs to build it in a repeatable, documented way.

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
                                                   |  lifecycle rules   |
                                                   +--------------------+

   AWS Billing --> CloudWatch alarm --> SNS --> owner's email
```

TODO: replace this with a proper diagram image (draw.io or Excalidraw) saved as `docs/architecture.png`.

### AWS services used

| Service | Role in the project |
|---------|--------------------|
| S3 (website bucket) | Stores the website files, kept private |
| CloudFront | Serves the site over HTTPS and caches it close to visitors |
| S3 (backup bucket) | Stores backups with versioning and encryption |
| IAM | A backup-only user with minimum permissions |
| CloudWatch + SNS | Billing alarm and email alerts |
| Terraform | Defines all of the above as code |

---

## 3. Key design decisions

Why things were built this way (full notes go in `docs/decisions.md`):

- **Private buckets, CloudFront in front.** Nobody can read the website bucket directly, which reduces the risk of accidental public exposure.
- **Versioning on the backup bucket.** If a file is overwritten or deleted by mistake, an older version can be restored.
- **Lifecycle rules.** Old backups move to cheaper storage so costs stay low as data grows.
- **Least-privilege IAM.** The backup user can upload but cannot delete, so a stolen laptop can't wipe the backups.
- **Infrastructure as code.** The whole setup can be destroyed and rebuilt from this repo in minutes, which also makes it easy to reuse for another client.

---

## 4. Security

- Both buckets block all public access.
- The backup bucket is encrypted at rest.
- Credentials are never stored in the repo (`.gitignore` excludes `.env`, `*.tfvars` and state files).
- MFA is enabled on the AWS root account, which is not used day to day.

TODO: add anything else you implement, such as bucket policies that require HTTPS.

---

## 5. Cost

This design is meant to cost very little at small-business scale, mostly storage and a few requests. The billing alarm is the safeguard in case that changes.

TODO: after building, add your real numbers here and link an AWS Pricing Calculator estimate (see `docs/cost-estimate.md`).

---

## 6. Repository structure

```
aws-small-business-cloud/
├── README.md              <- you are here
├── BUILD_ORDER.md         <- step-by-step build checklist
├── site/                  <- the website files
├── sample-data/           <- FAKE files to test backups (never real data)
├── terraform/             <- all infrastructure code
├── scripts/               <- deploy, backup and teardown helpers
└── docs/                  <- decisions, security, cost, restore guide
```

---

## 7. How to deploy

> TODO: confirm each command works for you, then adjust.

```bash
# 1. Configure AWS access
aws configure

# 2. Create your settings file
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
#    then edit it: bucket names (must be globally unique) and your alert email

# 3. Build the infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# 4. Upload the website and run a test backup
cd ..
./scripts/deploy.sh
./scripts/backup.sh
```

After `apply`, Terraform prints the CloudFront URL. Open it to see the website.

### Proving it works
- [ ] Website loads over HTTPS from the CloudFront URL
- [ ] A backup file uploads, and I can see it in the backup bucket
- [ ] I overwrite a file, then restore the older version (see `docs/restore-guide.md`)
- [ ] The billing alarm email subscription is confirmed

TODO: add screenshots of each to `docs/screenshots/`.

---

## 8. Teardown

Cloud resources can cost money if left running. When finished:

```bash
./scripts/teardown.sh
```

Buckets must be emptied before Terraform can delete them; the script is meant to handle that.

---

## 9. Future improvements

- Custom domain with Route 53 and a free HTTPS certificate (ACM)
- Scheduled automatic backups
- Copy backups to a second AWS region for disaster recovery
- Auto-deploy the website with GitHub Actions
- Remote Terraform state

---

## 10. What I learned

TODO: write 4-5 honest sentences in your own words, covering what was hard, what surprised you, and what you'd do differently.

VERIFICATION CODE-
WTC-C75CTTTF

## Screenshots

### Website live on CloudFront
![Sunrise Bakery live on CloudFront](docs/screenshots/part-a-website-live.png)

### Custom error page
![Custom error page served by CloudFront](docs/screenshots/part-a-error-page.png)