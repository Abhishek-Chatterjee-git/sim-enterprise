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
    'erasureOtpMessage','erasureError','erasureModalError','erasureStartButton','erasureVerifyButton',
    'erasureRequestActions']) elements.set(id,element());
  const main = element();
  const storage = new Map([['ecom_token','test-session'],['ecom_user','{"id":"test-user"}']]);
  const session = new Map();
  const calls=[];
  let verification = {ok:false,body:{error:'Invalid code'}};
  const context=vm.createContext({console,URL,Map,Set,
    window:{location:{pathname:'/privacy'}},
    document:{hidden:false,body:main,querySelector:()=>main,
      addEventListener(){},getElementById:id=>elements.get(id)||null,createElement:element},
    localStorage:{getItem:k=>storage.get(k)||null,removeItem:k=>storage.delete(k),setItem:(k,v)=>storage.set(k,v)},
    sessionStorage:{getItem:k=>session.get(k)||null,removeItem:k=>session.delete(k),setItem:(k,v)=>session.set(k,v)},
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
  return {context,elements,storage,session,calls,main,setVerification:value=>{verification=value;}};
}

test('OTP form is inline on the page, survives tab switches, supports retry, and logs out only after confirmation',async()=>{
  const {context,elements,storage,session,calls,main,setVerification}=ui();
  context.promptErasureModal();
  assert.equal(elements.get('erasureModal').classList.contains('hidden'),false);
  await context.executeAccountErasure();
  assert.equal(elements.get('erasureModal').classList.contains('hidden'),true,'confirmation popup must close after OTP starts');
  assert.equal(elements.get('erasureOtpForm').classList.contains('hidden'),false,'OTP must render inline on the page');
  assert.equal(elements.get('erasureRequestActions').classList.contains('hidden'),true);
  assert.ok(session.get('ecom_erasure_otp_pending'));
  const input=elements.get('erasureOtpCode'); input.value='123456';
  context.document.hidden=true; context.document.hidden=false;
  context.syncErasureOtpUi();
  assert.equal(elements.get('erasureOtpForm').classList.contains('hidden'),false);
  assert.equal(input.value,'123456');
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
  assert.equal(session.has('ecom_erasure_otp_pending'),false);
  assert.equal(vm.runInContext('currentUser',context),null);
  assert.equal(elements.get('erasureOtpForm').classList.contains('hidden'),true);
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

test('pending OTP state restores after reload without using a native prompt',async()=>{
  const first=ui();
  await first.context.executeAccountErasure();
  const pending=first.session.get('ecom_erasure_otp_pending');
  assert.ok(pending);

  const second=ui();
  second.session.set('ecom_erasure_otp_pending',pending);
  second.context.restoreErasureOtpState();
  second.context.syncErasureOtpUi();
  assert.equal(vm.runInContext('erasureVerificationPending',second.context),true);
  assert.equal(second.elements.get('erasureOtpForm').classList.contains('hidden'),false);
  assert.equal(second.elements.get('erasureModal').classList.contains('hidden'),true);
});
