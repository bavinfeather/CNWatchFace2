const fs=require('node:fs'),assert=require('node:assert/strict');
const source=fs.readFileSync(`${__dirname}/../source/CNWatchFaceView.mc`,'utf8');
const start=source.indexOf('private function updateActivityDistanceCache(date)');
const open=source.indexOf('{',start);
let depth=1,end=open+1;
while(depth){const c=source[end++];if(c==='{')depth++;if(c==='}')depth--;}
const code=source.slice(open+1,end-1)
 .replace('if (!(UserProfile has :getUserActivityHistory)) { return; }','')
 .replace(/Gregorian\.info\(activity.startTime, Time.FORMAT_SHORT\)/g,'activity.startTime')
 .replace(/(\w+(?:\.\w+)*) has :(\w+)/g,'"$2" in $1')
 .replace(/activity.startTime instanceof Time.Moment/g,'(typeof activity.startTime === "object" && activity.startTime !== null)')
 .replace(/activity.distance instanceof Lang\.(Number|Float)/g,'typeof activity.distance === "number"')
 .replace(/\(date.min \/ 5\)\.toNumber\(\)/g,'Math.trunc(date.min / 5)');
const date={year:2026,month:10,day:11,hour:12,min:0};
const ctx={_deferActivityHistoryRefresh:false,_activityDistanceCacheDay:-1,_activityDistanceCacheKey:-1,
 _activityDistanceIterator:null,_pendingRunningDistances:null,_pendingCyclingDistances:null,
 _runningDistances:null,_cyclingDistances:null,_totalDistanceSevenDays:null,
 totalDistanceFromHistory:()=>77,isCurrentWeek:()=>true,
 DISTANCE_PERIOD_DAY:0,DISTANCE_PERIOD_WEEK:1,DISTANCE_PERIOD_MONTH:2,DISTANCE_PERIOD_YEAR:3,
 Activity:{SPORT_RUNNING:1,SPORT_CYCLING:2},UserProfile:{}};
let reads=0,created=0,fail=false;
ctx.UserProfile.getUserActivityHistory=()=>{created++;let index=0;return {next(){
 reads++;if(fail)throw Error('API failure');
 if(index>=1500)return null;return {startTime:date,distance:1000,type:index++%2?2:1};
}};};
const update=new Function('ctx','date',`with(ctx){${code}}`);
function tick(d=date){const before=reads;update(ctx,d);assert.ok(reads-before<=32,'bounded reads per frame');}
for(let frame=0;frame<46;frame++){tick();assert.equal(ctx._runningDistances,null,'no partial totals');}
tick();assert.deepEqual(ctx._runningDistances,[750000,750000,750000,750000]);
assert.deepEqual(ctx._cyclingDistances,[750000,750000,750000,750000]);
assert.equal(created,1);tick();assert.equal(created,1,'completed cache reused');
const old=ctx._runningDistances;fail=true;tick({...date,min:5});
assert.equal(ctx._runningDistances,old,'failed scan preserves valid totals');
assert.equal(ctx._activityDistanceIterator,null);
fail=false;tick({...date,day:12});assert.equal(ctx._runningDistances,null,'new day drops yesterday totals');
assert.equal(ctx._totalDistanceSevenDays,77);
ctx._deferActivityHistoryRefresh=true;const before=reads;tick({...date,day:12});assert.equal(reads,before,'wake frame defers work');
ctx._deferActivityHistoryRefresh=false;
ctx._activityDistanceIterator=null;ctx._pendingRunningDistances=null;ctx._pendingCyclingDistances=null;
ctx.UserProfile.getUserActivityHistory=()=>null;
tick({...date,day:12,min:10});assert.equal(ctx._activityDistanceIterator,null);assert.equal(ctx._pendingRunningDistances,null,'invalid iterator is discarded');
const samples=[{}, {startTime:'bad',distance:100,type:1}, {startTime:date,distance:'bad',type:1},
 {startTime:date,distance:-1,type:1}, {startTime:date,distance:NaN,type:1}, {startTime:date,distance:Infinity,type:1},
 {startTime:date,distance:2000,type:1}, {startTime:date,distance:1000,type:2}];
ctx.UserProfile.getUserActivityHistory=()=>{let i=0;return {next(){return samples[i++]??null;}};};
tick({...date,day:12,min:15});assert.equal(ctx._runningDistances[3],2000);assert.equal(ctx._cyclingDistances[3],1000);
console.log('PASS: 1500 records, bounded reads, atomic totals, reuse, failure, rollover, wake deferral, invalid iterator and malformed records');
