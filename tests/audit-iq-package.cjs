const fs=require('node:fs'),path=require('node:path'),cp=require('node:child_process'),crypto=require('node:crypto'),assert=require('node:assert/strict');
const root=path.resolve(__dirname,'..'),version=fs.readFileSync(path.join(root,'VERSION'),'utf8').trim();
const release=path.join(root,'releases',version),iq=path.join(release,'GeometricMountainMAX2.iq');
const out=path.join(root,'work','package-audit-'+version);
fs.mkdirSync(out,{recursive:true});cp.execFileSync('tar',['-xf',iq,'-C',out]);
const manifest=fs.readFileSync(path.join(out,'manifest.xml'),'utf8');
const source=fs.readFileSync(path.join(root,'manifest.xml'),'utf8');
const products=[...source.matchAll(/<iq:product id="([^"]+)"/g)].map(m=>m[1]);
assert.equal(new Set(products).size,products.length);
const appId=source.match(/<iq:application id="([^"]+)"/)[1].replaceAll('-','');
assert.ok(manifest.includes(`id="${appId}"`));
const parts=[...manifest.matchAll(/<iq:product\s[^>]*partNumber="([^"]+)"/g)].map(m=>m[1]);
const expected=new Set();
for(const device of products){
 const profile=JSON.parse(fs.readFileSync(path.join(process.env.APPDATA,'Garmin/ConnectIQ/Devices',device,'compiler.json'),'utf8'));
 for(const part of profile.partNumbers)expected.add(part.number);
}
assert.deepEqual([...new Set(parts)].sort(),[...expected].sort());assert.equal(parts.length,expected.size);
const previous=path.join(root,'releases','1.3.7','GeometricMountainMAX2.iq');
let programs=0,settingsCount=0;
for(const part of parts){
 const dir=path.join(out,part);
 assert.ok(fs.statSync(path.join(dir,'GeometricMountainMAX2.prg')).size>0);programs++;
 const settingsFile=path.join(dir,part+'-settings.json');
 const settings=JSON.parse(fs.readFileSync(settingsFile,'utf8'));
 const keys=settings.settings.map(row=>row.key);
 assert.equal(new Set(keys).size,keys.length,part+': duplicate settings');
 const old=JSON.parse(cp.execFileSync('tar',['-xOf',previous,`${part}/${part}-settings.json`],{encoding:'utf8'}));
 assert.deepEqual(settings,old,part+': settings unexpectedly changed');settingsCount++;
}
for(const file of ['manifest.sig2','dev_key.pub'])assert.ok(fs.statSync(path.join(out,file)).size>0);
const publicKey=cp.execFileSync('tar',['-xOf',previous,'dev_key.pub']);
assert.ok(publicKey.equals(fs.readFileSync(path.join(out,'dev_key.pub'))),'signing identity changed');
const fingerprints=JSON.parse(fs.readFileSync(path.join(release,'source-fingerprints.json'),'utf8'));
for(const file of fingerprints)assert.equal(crypto.createHash('sha256').update(fs.readFileSync(path.join(root,file.Path))).digest('hex').toUpperCase(),file.Hash,'source changed during export: '+file.Path);
const log=fs.readFileSync(path.join(release,'build.log'),'utf8');
assert.ok(log.includes(`${expected.size} OUT OF ${expected.size} DEVICES BUILT`)&&log.includes('BUILD SUCCESSFUL'));
assert.ok(!/^\s*(?:ERROR|WARNING):/m.test(log),'compiler diagnostics');
const result={version,products:products.length,targets:parts.length,programs,settingsCount,
 bytes:fs.statSync(iq).size,sha256:crypto.createHash('sha256').update(fs.readFileSync(iq)).digest('hex').toUpperCase(),
 signingIdentityUnchanged:true,settingsUnchanged:true,snapshotStillMatches:true};
fs.writeFileSync(path.join(release,'PACKAGE_AUDIT.json'),JSON.stringify(result,null,2));
console.log(JSON.stringify(result,null,2));
