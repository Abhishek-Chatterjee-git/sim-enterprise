import {readFileSync} from 'node:fs';
import {createPublicKey,verify} from 'node:crypto';

const state = new URL('../../.d-fortress-ecommerce/data/',import.meta.url);
const journal = JSON.parse(readFileSync(new URL('agent-task-journal.json',state),'utf8'));
const task = journal.tasks[process.argv[2]];
if (!task?.receipt) throw new Error('Task receipt not found');
const {executionSignature,...payload} = task.receipt;
function sorted(value) {
  if (Array.isArray(value)) return value.map(sorted);
  if (value && typeof value === 'object') return Object.fromEntries(Object.keys(value).sort().map(key=>[key,sorted(value[key])]));
  return value;
}
const publicKey = createPublicKey(readFileSync(new URL('agent-signing-key.pem',state)));
const signature = Buffer.from(executionSignature,'base64');
const valid = verify(null,Buffer.from(JSON.stringify(sorted(payload))),publicKey,signature);
const tamperRejected = !verify(null,Buffer.from(JSON.stringify(sorted({...payload,recordsAffected:99}))),publicKey,signature);
console.log(JSON.stringify({taskId:task.taskId,state:task.state,executions:task.executions,
  status:payload.status,recordsAffected:payload.recordsAffected,matchedRows:payload.matchedRows,
  effectiveRowCap:payload.maxRows,signatureAlgorithm:payload.signatureAlg,
  signatureValid:valid,tamperRejected},null,2));
if (!valid || !tamperRejected) process.exitCode=1;
