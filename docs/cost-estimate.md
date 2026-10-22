# Cost notes

## Account plan
- AWS Free plan: $100 in credits at sign-up. The account closes after 6 months or when the credits run out, whichever comes first.
- A monthly cost budget (`bakery-monthly-budget`) is set to $5 and emails me at 85% and 100% of actual spend, and when forecasted spend is expected to reach 100%.
- Budgets send alerts but do not set hard spending limits.

## What can cost money in this project
| Item | What drives the cost | My choice |
|------|----------------------|-----------|
| S3 website bucket | Storage and requests | Three tiny files |
| S3 backup bucket | Storage, requests, extra stored versions | Versioning on, old versions deleted after 90 days |
| CloudFront | Data transfer and requests | Pay-as-you-go, $0 per month fixed (shown in the wizard) |
| WAF | Monthly fee plus per-request cost | Not enabled (about $14 per 10 million requests per month in the wizard estimate) |
| Origin Shield | Extra paid feature | Not enabled |
| IAM, budget | No charge for what I used | Not applicable |

## Observed so far
- Budgets page on 22 October 2026: $0.00 used of $5.00.
- Last month's cost shown when creating the budget: $0.00.
- Cost Explorer can take up to a day to show new data, so these numbers are early.

## How I will keep checking
- Look at the Budgets page and the Free Tier page for remaining credits.
- Delete test files and unused resources when I am done (see the cleanup checklist in `console-guide.md`).
- Note: I am not sure whether AWS applies credits before the budget compares spend with its limit. I will record what I see if an alert ever arrives.
