import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';
import vm from 'node:vm';

function ui() {
  const elements = new Map();
  const element = () => {
    const classes = new Set(['hidden']);
    return {value:'',textContent:'',disabled:false,children:[],
      classList:{add:c=>classes.add(c),remove:c=>classes.delete(c),contains:c=>classes.has(c),
        toggle(c,on) {if(on) classes.add(c); else classes.delete(c);}},
      focus(){},setAttribute(){},prepend(child){this.children.unshift(child);}};
  };
  for (const id of ['erasureModal','erasureConfirmation','erasureOtpForm','erasureOtpCode',
    'erasureOtpMessage','erasureError','erasureStartButton','erasureVerifyButton']) elements.set(id,element());
  const main = element();
  const storage = new Map([['ecom_token','test-session'],['ecom_user','{"id":"test-user"}']]);
  const calls=[];
  let verification = {ok:false,body:{error:'Invalid code'}};
  const context=vm.createContext({console,URL,Map,Set,
    window:{location:{pathname:'/privacy'}},
    document:{hidden:false,body:main,querySelector:()=>main,
      addEventListener(){},getElementById:id=>elements.get(id)||null,createElement:element},
    localStorage:{getItem:k=>storage.get(k)||null,removeItem:k=>storage.delete(k),setItem:(k,v)=>storage.set(k,v)},
    prompt(){throw new Error('Native prompt must not be used');},
    alert(){throw new Error('Native alert must not be used');},
    async fetch(path,options) {
      calls.push({path,options});
      const response=path.endsWith('/verify') ? verification
        : {ok:true,body:{status:'VERIFICATION_REQUIRED',message:'Check your inbox'}};
      return {ok:response.ok,json:async()=>response.body};
    },
  });
  vm.runInContext(readFileSync(new URL('../public/app.js',import.meta.url),'utf8'),context);
  vm.runInContext('currentUser={id:"test-user"};renderAuthHeader=()=>{};initPrivacyCenter=async()=>{};',context);
  return {context,elements,storage,calls,main,setVerification:value=>{verification=value;}};
}

test('OTP form survives tab switches and close/reopen, supports retry, and logs out only after confirmation',async()=>{
  const {context,elements,storage,calls,main,setVerification}=ui();
  context.promptErasureModal();
  await context.executeAccountErasure();
  assert.equal(elements.get('erasureOtpForm').classList.contains('hidden'),false);
  const input=elements.get('erasureOtpCode'); input.value='123456';
  context.document.hidden=true; context.document.hidden=false;
  context.closeErasureModal(); context.promptErasureModal();
  assert.equal(input.value,'123456');
  assert.equal(elements.get('erasureOtpForm').classList.contains('hidden'),false);
  const event={preventDefault(){}};
  await context.verifyAccountErasure(event);
  assert.equal(elements.get('erasureError').textContent,'Invalid code');
  assert.equal(input.value,'123456');
  assert.equal(storage.get('ecom_token'),'test-session');
  assert.equal(elements.get('erasureVerifyButton').disabled,false);
  setVerification({ok:true,body:{success:true,reference:'request-123'}});
  await context.verifyAccountErasure(event);
  assert.equal(storage.has('ecom_token'),false);
  assert.equal(storage.has('ecom_user'),false);
  assert.equal(vm.runInContext('currentUser',context),null);
  assert.equal(elements.get('erasureModal').classList.contains('hidden'),true);
  assert.equal(input.value,'');
  assert.match(main.children[0].textContent,/signed out.*request-123/);
  assert.deepEqual(calls.map(c=>c.path),['/api/privacy/dsr/erasure','/api/privacy/dsr/verify','/api/privacy/dsr/verify']);
});

test('incomplete OTP stays in the form without submitting or logging out',async()=>{
  const {context,elements,storage,calls}=ui();
  await context.executeAccountErasure();
  elements.get('erasureOtpCode').value='123';
  await context.verifyAccountErasure({preventDefault(){}});
  assert.equal(calls.length,1);
  assert.equal(storage.has('ecom_token'),true);
  assert.match(elements.get('erasureError').textContent,/six-digit/);
});
