/**
 * Client-Side Application for ARTISAN LUXE Simulated Enterprise
 * Handles Product Catalog, Cart, Onboarding, Privacy Center, and Live DPDP Enforcement
 */

// State
let currentUser = null;
let cart = [];
let allProducts = [];
let selectedCategory = 'ALL';
let authMode = 'signup'; // 'signup' | 'login'

// Init
document.addEventListener('DOMContentLoaded', async () => {
  if (window.lucide) {
    window.lucide.createIcons();
  }

  loadStoredSession();
  await loadProducts();
  updateCartUI();

  // If on Privacy Center page, initialize Privacy Center state
  if (window.location.pathname.includes('/privacy')) {
    await initPrivacyCenter();
  }
});

// ----------------------------------------------------------------------------
// 1. Authentication & Session Management
// ----------------------------------------------------------------------------
function loadStoredSession() {
  const token = localStorage.getItem('ecom_token');
  const userJson = localStorage.getItem('ecom_user');
  if (token && userJson) {
    try {
      currentUser = JSON.parse(userJson);
      renderAuthHeader();
    } catch {
      localStorage.removeItem('ecom_token');
      localStorage.removeItem('ecom_user');
    }
  } else {
    // Default demo user profile for smooth exploration
    currentUser = {
      id: 'usr-mumbai-101',
      fullName: 'Rohit Sharma',
      email: 'rohit.sharma@example.com',
      phone: '+919820123456',
    };
    renderAuthHeader();
  }
}

function renderAuthHeader() {
  const container = document.getElementById('authHeaderContainer');
  if (!container) return;

  if (currentUser) {
    container.innerHTML = `
      <div class="flex items-center space-x-2">
        <div class="text-right hidden sm:block">
          <span class="block text-xs font-semibold text-white">${currentUser.fullName}</span>
          <span class="block text-[10px] text-emerald-400 font-mono">${currentUser.email}</span>
        </div>
        <button onclick="handleLogout()" class="text-xs uppercase tracking-wider px-3.5 py-1.5 rounded-full border border-white/20 hover:bg-white/10 text-gray-300 transition">
          Sign Out
        </button>
      </div>
    `;
  } else {
    container.innerHTML = `
      <button onclick="openAuthModal('login')" class="text-xs uppercase tracking-wider px-4 py-2 rounded-full border border-white/20 hover:bg-white/10 text-white transition">
        Sign In
      </button>
      <button onclick="openAuthModal('signup')" class="text-xs uppercase tracking-wider px-4 py-2 rounded-full bg-aloe text-aloe-dark font-semibold hover:bg-emerald-300 transition">
        Register
      </button>
    `;
  }
}

function openAuthModal(mode = 'signup') {
  authMode = mode;
  const modal = document.getElementById('authModal');
  const title = document.getElementById('authModalTitle');
  const subtitle = document.getElementById('authModalSubtitle');
  const signupFields = document.getElementById('signupFields');
  const submitBtn = document.getElementById('authSubmitBtn');
  const togglePrompt = document.getElementById('authTogglePrompt');
  const toggleBtn = document.getElementById('authToggleBtn');
  const errorMsg = document.getElementById('authErrorMsg');

  if (errorMsg) errorMsg.classList.add('hidden');

  if (mode === 'signup') {
    title.textContent = 'Customer Registration';
    subtitle.textContent = 'DPDP Act 2025 Compliant Onboarding';
    signupFields.classList.remove('hidden');
    submitBtn.textContent = 'Complete Registration & Sign In';
    togglePrompt.textContent = 'Already registered?';
    toggleBtn.textContent = 'Sign In';
  } else {
    title.textContent = 'Customer Sign In';
    subtitle.textContent = 'Access your account & privacy center';
    signupFields.classList.add('hidden');
    submitBtn.textContent = 'Sign In';
    togglePrompt.textContent = "Don't have an account?";
    toggleBtn.textContent = 'Register';
  }

  modal.classList.remove('hidden');
}

function closeAuthModal() {
  const modal = document.getElementById('authModal');
  if (modal) modal.classList.add('hidden');
}

function toggleAuthMode() {
  openAuthModal(authMode === 'signup' ? 'login' : 'signup');
}

async function handleAuthSubmit(e) {
  e.preventDefault();
  const errorMsg = document.getElementById('authErrorMsg');
  const submitBtn = document.getElementById('authSubmitBtn');
  if (errorMsg) errorMsg.classList.add('hidden');

  const email = document.getElementById('authEmail')?.value.trim();
  const password = document.getElementById('authPassword')?.value;

  submitBtn.disabled = true;
  submitBtn.textContent = 'Processing...';

  try {
    if (authMode === 'signup') {
      const fullName = document.getElementById('authFullName')?.value.trim();
      const phone = document.getElementById('authPhone')?.value.trim();
      const aadhaarNo = document.getElementById('authAadhaar')?.value.trim();
      const panNo = document.getElementById('authPan')?.value.trim();
      const address = document.getElementById('authAddress')?.value.trim();
      const city = document.getElementById('authCity')?.value.trim();
      const state = document.getElementById('authState')?.value.trim();
      const pincode = document.getElementById('authPincode')?.value.trim();

      const consents = ['essential'];
      if (document.getElementById('consentMarketing')?.checked) consents.push('marketing');
      if (document.getElementById('consentAnalytics')?.checked) consents.push('analytics');

      const res = await fetch('/api/auth/signup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fullName, email, phone, password, aadhaarNo, panNo, address, city, state, pincode, consents }),
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Registration failed');

      localStorage.setItem('ecom_token', data.token);
      localStorage.setItem('ecom_user', JSON.stringify(data.user));
      currentUser = data.user;
    } else {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Login failed');

      localStorage.setItem('ecom_token', data.token);
      localStorage.setItem('ecom_user', JSON.stringify(data.user));
      currentUser = data.user;
    }

    closeAuthModal();
    renderAuthHeader();
    if (window.location.pathname.includes('/privacy')) {
      await initPrivacyCenter();
    }
  } catch (err) {
    if (errorMsg) {
      errorMsg.textContent = err.message;
      errorMsg.classList.remove('hidden');
    }
  } finally {
    submitBtn.disabled = false;
    submitBtn.textContent = authMode === 'signup' ? 'Complete Registration & Sign In' : 'Sign In';
  }
}

function handleLogout() {
  localStorage.removeItem('ecom_token');
  localStorage.removeItem('ecom_user');
  currentUser = null;
  renderAuthHeader();
  if (window.location.pathname.includes('/privacy')) {
    window.location.href = '/';
  }
}

// ----------------------------------------------------------------------------
// 2. Product Catalog & Storefront UI
// ----------------------------------------------------------------------------
async function loadProducts() {
  const grid = document.getElementById('productGrid');
  if (!grid) return;

  try {
    const res = await fetch('/api/products');
    const data = await res.json();
    allProducts = data.products || [];
    renderProductGrid();
  } catch (err) {
    console.error('Failed to load products:', err);
  }
}

function renderProductGrid() {
  const grid = document.getElementById('productGrid');
  if (!grid) return;

  const filtered = selectedCategory === 'ALL' 
    ? allProducts 
    : allProducts.filter((p) => p.category.toLowerCase() === selectedCategory.toLowerCase());

  if (filtered.length === 0) {
    grid.innerHTML = `
      <div class="col-span-full py-12 text-center text-gray-400 font-mono text-xs">
        No artisanal items found in this category.
      </div>
    `;
    return;
  }

  grid.innerHTML = filtered.map((p) => `
    <div class="bg-white rounded-2xl overflow-hidden shadow-paper shadow-paper-hover transition-all duration-300 border border-gray-100 flex flex-col group">
      <!-- Image & Badges -->
      <div class="relative h-64 overflow-hidden bg-gray-100">
        <img src="${p.image}" alt="${p.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
        <span class="absolute top-3 left-3 px-2.5 py-1 rounded-full bg-white/90 backdrop-blur-sm text-charcoal text-[10px] font-mono uppercase tracking-wider font-semibold border border-black/5">
          ${p.category}
        </span>
        <div class="absolute top-3 right-3 px-2 py-0.5 rounded-full bg-black/70 backdrop-blur-sm text-amber-400 text-xs font-semibold flex items-center gap-1">
          <i data-lucide="star" class="w-3 h-3 fill-amber-400"></i>
          <span>${p.rating}</span>
        </div>
      </div>

      <!-- Details -->
      <div class="p-6 flex flex-col flex-grow justify-between space-y-4">
        <div>
          <h3 class="font-editorial text-lg font-semibold text-charcoal group-hover:text-emerald-900 transition leading-snug">${p.name}</h3>
          <p class="text-xs text-gray-500 mt-1 line-clamp-2 leading-relaxed">${p.description}</p>
        </div>

        <div class="flex items-center justify-between pt-2 border-t border-gray-100">
          <div>
            <span class="text-[10px] text-gray-400 block font-mono">Price (Incl. GST)</span>
            <span class="font-editorial text-xl font-bold text-charcoal">₹${Number(p.price).toLocaleString('en-IN')}</span>
          </div>

          <button onclick="addToCart('${p.id}')" class="px-4 py-2 rounded-full bg-charcoal text-white text-xs font-medium hover:bg-emerald-900 transition flex items-center gap-1.5 shadow-sm">
            <i data-lucide="plus" class="w-3.5 h-3.5"></i>
            <span>Add to Bag</span>
          </button>
        </div>
      </div>
    </div>
  `).join('');

  if (window.lucide) {
    window.lucide.createIcons();
  }
}

function filterCategory(cat) {
  selectedCategory = cat;
  document.querySelectorAll('.category-pill').forEach((btn) => {
    if (btn.textContent.trim().toLowerCase().includes(cat.toLowerCase()) || (cat === 'ALL' && btn.textContent.includes('All'))) {
      btn.className = 'category-pill px-4 py-1.5 rounded-full text-xs font-medium bg-charcoal text-white transition';
    } else {
      btn.className = 'category-pill px-4 py-1.5 rounded-full text-xs font-medium bg-white text-gray-700 border border-gray-200 hover:bg-gray-50 transition';
    }
  });
  renderProductGrid();
}

// ----------------------------------------------------------------------------
// 3. Shopping Cart Management & Order Execution
// ----------------------------------------------------------------------------
function addToCart(productId) {
  const prod = allProducts.find((p) => p.id === productId);
  if (!prod) return;

  const existing = cart.find((item) => item.id === productId);
  if (existing) {
    existing.quantity += 1;
  } else {
    cart.push({ ...prod, quantity: 1 });
  }

  updateCartUI();
  toggleCartDrawer(true);
}

function updateCartUI() {
  const badge = document.getElementById('cartCountBadge');
  const list = document.getElementById('cartItemsList');
  const subtotalEl = document.getElementById('cartSubtotal');

  const totalCount = cart.reduce((sum, itm) => sum + itm.quantity, 0);
  const totalAmount = cart.reduce((sum, itm) => sum + itm.price * itm.quantity, 0);

  if (badge) badge.textContent = totalCount;
  if (subtotalEl) subtotalEl.textContent = `₹${totalAmount.toLocaleString('en-IN')}`;

  if (!list) return;

  if (cart.length === 0) {
    list.innerHTML = `
      <div class="py-16 text-center text-gray-400 font-mono text-xs">
        <i data-lucide="shopping-bag" class="w-8 h-8 mx-auto text-gray-300 mb-2"></i>
        <p>Your bag is empty.</p>
      </div>
    `;
    if (window.lucide) window.lucide.createIcons();
    return;
  }

  list.innerHTML = cart.map((itm) => `
    <div class="flex items-center gap-3 p-3 bg-paper rounded-xl border border-gray-100">
      <img src="${itm.image}" alt="${itm.name}" class="w-14 h-14 object-cover rounded-lg">
      <div class="flex-grow">
        <h4 class="text-xs font-bold text-charcoal line-clamp-1">${itm.name}</h4>
        <span class="text-xs text-gray-500 font-mono">₹${Number(itm.price).toLocaleString('en-IN')} × ${itm.quantity}</span>
      </div>
      <button onclick="removeFromCart('${itm.id}')" class="p-1 text-gray-400 hover:text-red-600 rounded">
        <i data-lucide="trash-2" class="w-4 h-4"></i>
      </button>
    </div>
  `).join('');

  if (window.lucide) window.lucide.createIcons();
}

function removeFromCart(productId) {
  cart = cart.filter((i) => i.id !== productId);
  updateCartUI();
}

function toggleCartDrawer(forceOpen = false) {
  const drawer = document.getElementById('cartDrawer');
  if (!drawer) return;
  if (forceOpen) {
    drawer.classList.remove('hidden');
  } else {
    drawer.classList.toggle('hidden');
  }
}

async function executeCheckout() {
  if (cart.length === 0) {
    alert('Your bag is empty!');
    return;
  }

  const token = localStorage.getItem('ecom_token');
  const items = cart.map((i) => ({
    productId: i.id,
    productName: i.name,
    sku: i.sku,
    quantity: i.quantity,
    unitPrice: i.price,
  }));

  try {
    const res = await fetch('/api/orders', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: token ? `Bearer ${token}` : '',
      },
      body: JSON.stringify({
        userId: currentUser?.id || 'usr-mumbai-101',
        items,
        shippingAddress: 'Flat 14B, Sea Breeze Apartments, Worli Sea Face, Mumbai 400018',
        paymentMethod: 'UPI (Razorpay Gateway)',
      }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Checkout failed');

    cart = [];
    updateCartUI();
    toggleCartDrawer(false);

    alert(`🎉 Order Placed Successfully!\nOrder Number: ${data.orderNumber}\nAmount: ₹${data.totalAmount.toLocaleString('en-IN')}\n\nStatutory DPDP Tax Invoice recorded.`);
  } catch (err) {
    alert(`Order placement error: ${err.message}`);
  }
}

// ----------------------------------------------------------------------------
// 4. Customer Privacy & Consent Management Portal
// ----------------------------------------------------------------------------
async function initPrivacyCenter() {
  const userEmailEl = document.getElementById('privacyUserEmail');
  const statusBadge = document.getElementById('privacyUserStatusBadge');
  const quarantineBanner = document.getElementById('quarantineBanner');
  const marketingPill = document.getElementById('marketingStatusPill');
  const analyticsPill = document.getElementById('analyticsStatusPill');
  const toggleMkt = document.getElementById('toggleMarketing');
  const toggleAnl = document.getElementById('toggleAnalytics');

  const token = localStorage.getItem('ecom_token');
  const email = currentUser?.email || 'rohit.sharma@example.com';
  if (userEmailEl) userEmailEl.textContent = email;

  try {
    const res = await fetch('/api/privacy/status', {
      headers: { Authorization: token ? `Bearer ${token}` : '' },
    });
    const data = await res.json();

    if (data.status === 'SOFT_DELETED' || data.status === 'QUARANTINED') {
      if (statusBadge) {
        statusBadge.textContent = 'SCHEDULED FOR ERASURE';
        statusBadge.className = 'inline-block mt-2 text-[10px] font-bold font-mono px-2.5 py-0.5 rounded-full bg-red-100 text-red-800';
      }
      if (quarantineBanner) quarantineBanner.classList.remove('hidden');
    } else {
      if (statusBadge) {
        statusBadge.textContent = 'ACTIVE PRINCIPAL';
        statusBadge.className = 'inline-block mt-2 text-[10px] font-bold font-mono px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800';
      }
      if (quarantineBanner) quarantineBanner.classList.add('hidden');
    }

    // Set toggle positions
    const mktConsent = data.consents?.find((c) => c.purposeId === 'marketing')?.isGranted ?? true;
    const anlConsent = data.consents?.find((c) => c.purposeId === 'analytics')?.isGranted ?? true;

    if (toggleMkt) toggleMkt.checked = mktConsent;
    if (toggleAnl) toggleAnl.checked = anlConsent;

    if (marketingPill) {
      marketingPill.textContent = mktConsent ? 'Consent Active' : 'Consent Revoked';
      marketingPill.className = mktConsent 
        ? 'text-[10px] font-mono uppercase px-2 py-0.5 rounded bg-aloe text-aloe-dark font-semibold'
        : 'text-[10px] font-mono uppercase px-2 py-0.5 rounded bg-red-100 text-red-800 font-semibold';
    }

    if (analyticsPill) {
      analyticsPill.textContent = anlConsent ? 'Consent Active' : 'Consent Revoked';
      analyticsPill.className = anlConsent 
        ? 'text-[10px] font-mono uppercase px-2 py-0.5 rounded bg-aloe text-aloe-dark font-semibold'
        : 'text-[10px] font-mono uppercase px-2 py-0.5 rounded bg-red-100 text-red-800 font-semibold';
    }
  } catch (err) {
    console.error('Failed to load privacy status:', err);
  }
}

async function handleConsentToggle(purposeId, isGranted) {
  const token = localStorage.getItem('ecom_token');
  const pill = document.getElementById(`${purposeId}StatusPill`);

  if (pill) {
    pill.textContent = isGranted ? 'Consent Active' : 'Consent Revoked';
    pill.className = isGranted 
      ? 'text-[10px] font-mono uppercase px-2 py-0.5 rounded bg-aloe text-aloe-dark font-semibold'
      : 'text-[10px] font-mono uppercase px-2 py-0.5 rounded bg-red-100 text-red-800 font-semibold';
  }

  try {
    const res = await fetch('/api/privacy/consent/update', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: token ? `Bearer ${token}` : '',
      },
      body: JSON.stringify({
        userId: currentUser?.id || 'usr-mumbai-101',
        purposeId,
        isGranted,
      }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed to update consent');

    console.log(`[Privacy Center] Consent updated for ${purposeId}: ${isGranted}`);
  } catch (err) {
    alert(`Could not update consent: ${err.message}`);
  }
}

function promptErasureModal() {
  const modal = document.getElementById('erasureModal');
  if (modal) modal.classList.remove('hidden');
}

function closeErasureModal() {
  const modal = document.getElementById('erasureModal');
  if (modal) modal.classList.add('hidden');
}

async function executeAccountErasure() {
  closeErasureModal();
  const token = localStorage.getItem('ecom_token');

  try {
    const res = await fetch('/api/privacy/dsr/erasure', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: token ? `Bearer ${token}` : '',
      },
      body: JSON.stringify({
        userId: currentUser?.id || 'usr-mumbai-101',
        reason: 'Customer initiated DPDP Act 2025 §12 Right to Erasure',
      }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Erasure request failed');

    alert(`🛡️ DPDP Right to Erasure Scheduled!\n${data.message}`);
    await initPrivacyCenter();
  } catch (err) {
    alert(`Erasure failed: ${err.message}`);
  }
}

async function restoreAccount() {
  try {
    const res = await fetch('/api/privacy/dsr/reactivate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: currentUser?.email || 'rohit.sharma@example.com' }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Restoration failed');

    alert('🎉 Account Restored Successfully to ACTIVE status!');
    await initPrivacyCenter();
  } catch (err) {
    alert(`Account restore failed: ${err.message}`);
  }
}

// ----------------------------------------------------------------------------
// 5. Live DPDP Promotional Campaign & Enforcement Test Bench
// ----------------------------------------------------------------------------
function openTestBenchModal() {
  const modal = document.getElementById('testBenchModal');
  if (modal) {
    const emailInput = document.getElementById('testBenchEmail');
    if (emailInput && currentUser) {
      emailInput.value = currentUser.email;
    }
    modal.classList.remove('hidden');
  }
}

function closeTestBenchModal() {
  const modal = document.getElementById('testBenchModal');
  if (modal) modal.classList.add('hidden');
}

async function dispatchPromoTest() {
  const email = document.getElementById('testBenchEmail')?.value.trim();
  const msg = document.getElementById('testBenchMessage')?.value.trim();
  const resultBox = document.getElementById('testBenchResult');
  const btn = document.getElementById('testBenchDispatchBtn');

  if (!email) return;

  btn.disabled = true;
  btn.textContent = 'Checking In-VPC Zone Agent Consent...';

  try {
    const res = await fetch('/api/marketing/dispatch-promo', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ recipientEmail: email, promoMessage: msg }),
    });

    const data = await res.json();
    resultBox.classList.remove('hidden');

    if (res.ok) {
      resultBox.className = 'p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-xs font-mono space-y-1.5 text-emerald-900';
      resultBox.innerHTML = `
        <div class="flex items-center gap-2 font-bold text-emerald-800">
          <i data-lucide="check-circle-2" class="w-4 h-4 text-emerald-600"></i>
          <span>DISPATCH PERMITTED (200 OK)</span>
        </div>
        <div class="text-[11px] text-emerald-700">
          • Principal: ${data.recipient}<br>
          • Check Latency: ${data.complianceCheck.latencyMs} ms (&lt;1ms in-VPC cache)<br>
          • Verified By: ${data.complianceCheck.enforcedBy}<br>
          • Statutory Status: VERIFIED_ACTIVE_CONSENT (DPDP §6)
        </div>
      `;
    } else {
      resultBox.className = 'p-4 rounded-xl bg-red-50 border border-red-200 text-xs font-mono space-y-1.5 text-red-900';
      resultBox.innerHTML = `
        <div class="flex items-center gap-2 font-bold text-red-800">
          <i data-lucide="shield-alert" class="w-4 h-4 text-red-600"></i>
          <span>DISPATCH BLOCKED BY DPDP ENFORCEMENT (403 FORBIDDEN)</span>
        </div>
        <div class="text-[11px] text-red-700">
          • Principal: ${email}<br>
          • Statutory Clause: ${data.statutoryClause}<br>
          • Reason: ${data.message}<br>
          • Gated At: In-VPC Edge Agent Cache (${data.latencyMs} ms)
        </div>
      `;
    }

    if (window.lucide) window.lucide.createIcons();
  } catch (err) {
    resultBox.classList.remove('hidden');
    resultBox.className = 'p-4 rounded-xl bg-gray-50 border border-gray-200 text-xs font-mono text-gray-700';
    resultBox.textContent = `Error executing test: ${err.message}`;
  } finally {
    btn.disabled = false;
    btn.innerHTML = '<i data-lucide="send" class="w-4 h-4"></i><span>Execute Gated Campaign Dispatch</span>';
    if (window.lucide) window.lucide.createIcons();
  }
}
