# CRM – fresh Firebase setup

The code no longer points at `leadcapture-79a43`. Create a NEW project and fill in the placeholders.

## 1. Create the project
1. console.firebase.google.com → Add project (e.g. `crm-srisoftwarez`) → upgrade to **Blaze** (needed for Functions + scheduled jobs).
2. Enable: **Authentication → Email/Password**, **Firestore** (production mode), **Storage**, **Cloud Messaging**.
3. Firestore & Storage location: pick the same region you want to keep long-term (can't change later).

## 2. Connect the app
```bash
npm i -g firebase-tools && dart pub global activate flutterfire_cli
firebase login
flutterfire configure --project=<NEW_PROJECT_ID> \
  --android-package-name=com.srisoftwarez.crm --ios-bundle-id=com.srisoftwarez.crm \
  --platforms=android,ios,web,windows,macos
```
This regenerates `lib/firebase_options.dart` and `android/app/google-services.json`.
Then manually update:
- `lib/constants/src/strings.dart` → `firebaseProjectId`, `smtpUser`, `smtpPass`
- `web/firebase-messaging-sw.js` → copy the web config values
- `.firebaserc` → replace `YOUR_CRM_PROJECT_ID`
- Android: add SHA-1/SHA-256 of your keystore in Project settings.

## 3. Deploy backend
```bash
cd functions && cp .env.example .env     # put the NEW project's Web API key in FIREBASE_API_KEY
npm install && cd ..
firebase deploy --only functions,firestore,storage
```
Functions deployed: sendEmail, verifyAuth, updateUserPassword, deleteUserByEmail, removeoldNotifications, reminderScheduler, onEventWritten, sendEventStartNotifications.
Replace `firestore.rules` / `storage.rules` with the real rules from the old project's console first.
Firestore indexes: if a query errors with a "create index" link, click it (or export the old ones with `firebase firestore:indexes --project OLD_ID`).

## 4. FCM push (HTTP v1)
The app reads a service-account JSON from Firestore doc `system/serviceAccount` (field `account` = the JSON as a string).
Project settings → Service accounts → Generate new private key → paste into that field.

## 5. Seed data
Collections (users, admins, notifications, reminders, backups, download_history, errors, system, version, regions, …) are created automatically by the app.
- Reference data: `OLD_KEY=old.json NEW_KEY=new.json node scripts/copy_reference_data.js`
- First admin: use the app's company registration screen.
- Windows/Android self-update reads the `version` collection.
