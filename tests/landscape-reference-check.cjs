const fs=require('node:fs'),assert=require('node:assert/strict');
const source=fs.readFileSync(`${__dirname}/../source/CNWatchFaceView.mc`,'utf8');
const start=source.indexOf('private function drawMountains('),open=source.indexOf('{',start);
let depth=1,end=open+1;
while(depth){const c=source[end++];if(c==='{')depth++;if(c==='}')depth--;}
const code=source.slice(open+1,end-1).replace('(Graphics has :createBufferedBitmap)','true')
 .replace(/:(\w+)\s*=>/g,'$1:');
let now=100,creates=0,renders=0,draws=0,cached=true,unavailable=false;
const bufferDc={setColor(){},clear(){}};
const bitmap={isCached:()=>cached,getDc:()=>bufferDc};
const reference={get(){if(unavailable)throw Error('Graphics pool full');return bitmap;}};
const ctx={sky:0,far:0,mid:0,near:0,_width:454,_height:454,_landscapeBitmap:null,_landscapeNextRetrySeconds:0,
 prepareLandscape(){},isAmoledLayout:()=>true,COLOR_BLACK:0,
 renderLandscape(){renders++;},Time:{now:()=>({value:()=>now})},
 Graphics:{createBufferedBitmap(){creates++;return reference;}},
 Lang:{InvalidValueException:Error}};
const dc={drawBitmap(x,y,value){assert.equal(value,bitmap);draws++;}};
const draw=new Function('ctx','dc',`with(ctx){${code}}`);
draw(ctx,dc);assert.equal(ctx._landscapeBitmap,reference,'retain reclaimable reference, not locked bitmap');
assert.equal(creates,1);assert.equal(renders,1);assert.equal(draws,1);
draw(ctx,dc);assert.equal(renders,1,'unchanged buffer reused');
cached=false;draw(ctx,dc);assert.equal(renders,2,'purged contents re-rendered');
unavailable=true;draw(ctx,dc);assert.equal(ctx._landscapeBitmap,null);
assert.equal(renders,3,'graphics failure draws direct fallback');
draw(ctx,dc);assert.equal(creates,1,'retry is rate limited');
now=161;unavailable=false;cached=true;draw(ctx,dc);
assert.equal(creates,2);assert.equal(ctx._landscapeBitmap,reference);
console.log('PASS: reclaimable reference, reuse, restoration, graphics failure fallback and retry');
