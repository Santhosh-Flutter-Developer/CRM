// Copies reference/static collections (NOT user or business data) from the old project to the new one.
// Usage:
//   cd functions && npm i && cd ..
//   OLD_KEY=old-service-account.json NEW_KEY=new-service-account.json node scripts/copy_reference_data.js
// Edit COLLECTIONS below if you want more/less copied.
const path = require("path");
const admin = require(path.join(__dirname, "../functions/node_modules/firebase-admin"));

const COLLECTIONS = ["regions", "version"]; // regions includes sub-collections (states/cities) if nested
const oldApp = admin.initializeApp({ credential: admin.credential.cert(require(path.resolve(process.env.OLD_KEY))) }, "old");
const newApp = admin.initializeApp({ credential: admin.credential.cert(require(path.resolve(process.env.NEW_KEY))) }, "new");
const src = oldApp.firestore(), dst = newApp.firestore();

async function copyCollection(srcCol, dstCol) {
  const snap = await srcCol.get();
  for (const doc of snap.docs) {
    await dstCol.doc(doc.id).set(doc.data());
    for (const sub of await doc.ref.listCollections()) {
      await copyCollection(sub, dstCol.doc(doc.id).collection(sub.id));
    }
  }
  console.log(`copied ${srcCol.path} (${snap.size} docs)`);
}
(async () => { for (const c of COLLECTIONS) await copyCollection(src.collection(c), dst.collection(c)); })();
