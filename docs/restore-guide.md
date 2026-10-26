# Restore guide (for the business owner)

The backup bucket keeps older versions of every file, so a file that was overwritten or deleted by mistake can usually be recovered.
You need to be signed in to the AWS console with an account that is allowed to manage the bucket. The upload-only backup user cannot do this on purpose.

## Open the bucket
1. Sign in to the AWS console and open **S3**.
2. Click the bucket `andiswa-bakery-backups-2026`.
3. Turn on **Show versions** (the switch next to the search box).

## If a file was overwritten with the wrong content
1. Find the file. Each version is listed on its own row with a date and time.
2. Click the **older version** you want.
3. Click **Download** and open the file to check it is the right one.
4. Upload that file back into the bucket with the same name. The restored copy becomes the newest version.

## If a file was deleted
1. With **Show versions** on, look for a row labelled **Delete marker** for that file.
2. Select the delete marker and click **Delete**. Confirm when asked.
3. Turn off **Show versions**. The file should be visible again.

## Limits to know about
- Older versions are removed automatically **90 days** after they are replaced or deleted, so recover files within that time.
- Small files under 128 KB are not moved to cheaper storage by the lifecycle rule, but they are still kept as versions.
- If a file cannot be found, check that the bucket and region (Europe, Stockholm) are the right ones.
