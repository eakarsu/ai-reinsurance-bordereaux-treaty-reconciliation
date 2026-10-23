import test from "node:test";
import assert from "node:assert/strict";
import { filterRecords, recordsToCsv, buildInsights } from "../featurePack.mjs";
const rows=[{id:1,reference:"A-1",title:"Alpha case",status:"Open",risk:"High",amount:0},{id:2,reference:"B-2",title:"Beta case",status:"Closed",risk:"Low",amount:50}];
test("search/filter on main list",()=>{assert.equal(filterRecords(rows,{q:"alpha"}).length,1);assert.equal(filterRecords(rows,{status:"Closed"}).length,1);assert.equal(filterRecords(rows,{risk:"High"})[0].reference,"A-1");assert.equal(filterRecords(rows,{q:"missing"}).length,0);});
test("CSV/JSON export preserves 0/false/empty",()=>{const csv=recordsToCsv(rows);assert.match(csv,/A-1/);assert.match(csv,/^id,reference/m);assert.equal(JSON.parse(JSON.stringify(rows))[0].amount,0);});
test("deterministic insights labelled aiGenerated:false",()=>{const out=buildInsights(rows,{id:"f1",title:"Bordereaux treaty reconciliation"});assert.equal(out.aiGenerated,false);assert.equal(out.source,"deterministic-fallback");assert.equal(out.insights.length,3);assert.equal(out.insights[0].metrics.recordCount,2);assert.equal(out.insights[0].metrics.totalAmount,50);assert.equal(buildInsights([],{title:"X"}).insights[0].metrics.totalAmount,0);});
