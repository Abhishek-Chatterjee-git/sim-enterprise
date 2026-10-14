/**
 * Client-Side Application for ARTISAN LUXE Simulated Enterprise
 * Handles Product Catalog, Cart, Onboarding, Privacy Center, and Consent Management
 */

// State
let currentUser = null;
let cart = [];
let allProducts = [];
let selectedCategory = 'ALL';
let authMode = 'signup'; // 'signup' | 'login'
let erasureVerificationPending = false;
let erasureBusy = false;
const ERASURE_OTP_STORAGE_KEY = 'ecom_erasure_otp_pending';

// ----------------------------------------------------------------------------
// Curated Luxury Indian Artisanal Reserve Catalog
// ----------------------------------------------------------------------------
const defaultProducts = [
  {
    id: 'prod-01',
    name: 'Handcrafted Kashmiri Pashmina Shawl',
    sku: 'LUXE-KASH-001',
    category: 'Heritage Textiles',
    price: 18500,
    rating: 4.9,
    image: 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=800&auto=format&fit=crop&q=80',
    stock: 15,
    description: 'Authentic 100% Changthangi goat wool hand-spun in Srinagar. Pure luxury and timeless elegance.',
  },
  {
    id: 'prod-02',
    name: 'Organic Darjeeling First Flush (Estate Reserve)',
    sku: 'GOUR-DARJ-002',
    category: 'Gourmet Teas',
    price: 2400,
    rating: 4.8,
    image: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=800&auto=format&fit=crop&q=80',
    stock: 60,
    description: 'Single-estate loose leaf tea harvested at dawn from the misty Himalayan foothills of Darjeeling.',
  },
  {
    id: 'prod-03',
    name: 'Pure Mysore Sandalwood Essential Extract (50ml)',
    sku: 'WELL-SAND-003',
    category: 'Ayurvedic Wellness',
    price: 5200,
    rating: 5.0,
    image: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=800&auto=format&fit=crop&q=80',
    stock: 30,
    description: 'Steam-distilled from mature Santalum album heartwood. Deeply grounding therapeutic aroma.',
  },
  {
    id: 'prod-04',
    name: 'Jaipur Hand-Painted Cobalt Blue Pottery Vase',
    sku: 'DECO-JAIP-004',
    category: 'Artisan Decor',
    price: 3800,
    rating: 4.7,
    image: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&auto=format&fit=crop&q=80',
    stock: 22,
    description: 'Crafted using quartz stone and natural copper oxide pigments by master craftsmen in Jaipur.',
  },
  {
    id: 'prod-05',
    name: 'Heritage Brass Mayur Hanging Diya (Set of 2)',
    sku: 'DECO-DIYA-005',
    category: 'Artisan Decor',
    price: 4600,
    rating: 4.9,
    image: 'https://images.unsplash.com/photo-1605371924599-2d0365da1ae0?w=800&auto=format&fit=crop&q=80',
    stock: 18,
    description: 'Lost-wax cast solid brass peacock lamps crafted in Thanjavur. Traditional handcrafted finish.',
  },
  {
    id: 'prod-06',
    name: 'Raw Single-Origin Malabar Forest Honey (500g)',
    sku: 'GOUR-HONY-006',
    category: 'Gourmet Teas',
    price: 1250,
    rating: 4.8,
    image: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=800&auto=format&fit=crop&q=80',
    stock: 45,
    description: 'Wild-harvested, unpasteurized forest honey from the Nilgiri biosphere reserve.',
  },
];

// ----------------------------------------------------------------------------
// Initialization
// ----------------------------------------------------------------------------
document.addEventListener('DOMContentLoaded', async () => {
  if (window.lucide) {
    window.lucide.createIcons();
  }

  loadStoredSession();
  restoreErasureOtpState();
  await loadProducts();
  updateCartUI();

  // If on Privacy Center page, initialize Privacy Center state
  if (window.location.pathname.includes('/privacy') || window.location.pathname.includes('/privacy-center')) {
    await initPrivacyCenter();
    syncErasureOtpUi();
  }
});

// Keep the inline OTP panel visible if the tab is backgrounded and restored.
document.addEventListener('visibilitychange', () => {
  if (!document.hidden && erasureVerificationPending) syncErasureOtpUi();
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
      currentUser = null;
      renderAuthHeader();
    }
  } else {
    currentUser = null;
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
          <span class="block text-xs font-semibold text-white">${currentUser.fullName || 'Customer'}</span>
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
  const signupOnlyFields = document.getElementById('signupOnlyFields') || document.getElementById('signupFields');
  const submitBtn = document.getElementById('authSubmitBtn');
  const togglePrompt = document.getElementById('authTogglePrompt');
  const toggleBtn = document.getElementById('authToggleBtn');
  const errorMsg = document.getElementById('authErrorMsg');

  if (errorMsg) errorMsg.classList.add('hidden');
  let returnNotice = document.getElementById('returnPrivacyNotice');
  if (!returnNotice && submitBtn) {
    returnNotice = document.createElement('section');
    returnNotice.id = 'returnPrivacyNotice';
    returnNotice.className = 'hidden space-y-3 rounded-lg border border-gray-300 p-4 text-sm';
    returnNotice.innerHTML = `<h3 class="font-semibold">Review privacy notice — version 2.1</h3>
      <p>We use your account details to provide your account and process orders. Marketing and analytics are optional.
      You can change consent or request erasure in your privacy centre.</p>
      <p>Returning withdraws your pending erasure request. It does not restore data already erased.</p>
      <a href="/privacy" target="_blank" rel="noopener" class="underline">Review privacy preferences and rights</a>
      <label class="block"><input type="checkbox" id="returnPrivacyAccepted"> I have read and accept this privacy notice and want to withdraw my pending erasure request.</label>
      <label class="block"><input type="checkbox" id="returnMarketing"> Allow marketing communications</label>
      <label class="block"><input type="checkbox" id="returnAnalytics"> Allow analytics</label>`;
    submitBtn.before(returnNotice);
  }
  if (returnNotice) returnNotice.classList.toggle('hidden', mode !== 'return');
  for (const id of ['returnPrivacyAccepted','returnMarketing','returnAnalytics']) {
    const checkbox = document.getElementById(id);
    if (checkbox) checkbox.checked = false;
  }

  if (mode === 'signup') {
    if (title) title.textContent = 'Customer Registration';
    if (subtitle) subtitle.textContent = 'Create your personal account';
    if (signupOnlyFields) signupOnlyFields.classList.remove('hidden');
    if (submitBtn) submitBtn.textContent = 'Complete Registration & Sign In';
    if (togglePrompt) togglePrompt.textContent = 'Already have an account?';
    if (toggleBtn) toggleBtn.textContent = 'Sign In';
  } else {
    if (title) title.textContent = 'Customer Sign In';
    if (subtitle) subtitle.textContent = 'Enter your email and password to access your account';
    if (signupOnlyFields) signupOnlyFields.classList.add('hidden');
    if (submitBtn) submitBtn.textContent = 'Sign In';
    if (togglePrompt) togglePrompt.textContent = "Don't have an account?";
    if (toggleBtn) toggleBtn.textContent = 'Register';
  }
  if (mode === 'return') {
    if (title) title.textContent = 'Return to your account';
    if (subtitle) subtitle.textContent = 'Available within six months, while erasure has not been dispatched';
    if (submitBtn) submitBtn.textContent = 'Accept Privacy Notice & Return';
  }

  if (modal) modal.classList.remove('hidden');
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

  if (submitBtn) {
    submitBtn.disabled = true;
    submitBtn.textContent = 'Processing...';
  }

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
    } else if (authMode === 'return') {
      if (!document.getElementById('returnPrivacyAccepted')?.checked) throw new Error('Please read and accept the privacy notice.');
      const consents = ['essential'];
      if (document.getElementById('returnMarketing')?.checked) consents.push('marketing');
      if (document.getElementById('returnAnalytics')?.checked) consents.push('analytics');
      const res = await fetch('/api/privacy/dsr/reactivate', {
        method:'POST',headers:{'Content-Type':'application/json'},
        body:JSON.stringify({email,password,privacyAccepted:true,noticeVersion:'2.1',consents}),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Account return failed');
      localStorage.setItem('ecom_token',data.token);
      localStorage.setItem('ecom_user',JSON.stringify(data.user));
      currentUser = data.user;
    } else {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      const data = await res.json();
      if (!res.ok && data.requiresPrivacyAcceptance) {
        openAuthModal('return');
        return;
      }
      if (!res.ok) throw new Error(data.error || 'Invalid credentials');

      localStorage.setItem('ecom_token', data.token);
      localStorage.setItem('ecom_user', JSON.stringify(data.user));
      currentUser = data.user;
    }

    closeAuthModal();
    document.getElementById('erasureSubmittedNotice')?.remove();
    renderAuthHeader();
    if (window.location.pathname.includes('/privacy') || window.location.pathname.includes('/privacy-center')) {
      await initPrivacyCenter();
    }
  } catch (err) {
    if (errorMsg) {
      errorMsg.textContent = err.message || 'Authentication error';
      errorMsg.classList.remove('hidden');
    }
  } finally {
    if (submitBtn) {
      submitBtn.disabled = false;
      submitBtn.textContent = authMode === 'return' ? 'Accept Privacy Notice & Return'
        : authMode === 'signup' ? 'Complete Registration & Sign In' : 'Sign In';
    }
  }
}

function handleLogout() {
  localStorage.removeItem('ecom_token');
  localStorage.removeItem('ecom_user');
  currentUser = null;
  clearErasureOtpState();
  closeErasureModal();
  renderAuthHeader();
  if (window.location.pathname.includes('/privacy') || window.location.pathname.includes('/privacy-center')) {
    initPrivacyCenter();
  }
}

// ----------------------------------------------------------------------------
// 2. Product Catalog & Storefront UI
// ----------------------------------------------------------------------------
async function loadProducts() {
  const grid = document.getElementById('productGrid');
  if (!grid) return;

  // Immediate render from default catalog so UI is never blank
  allProducts = [...defaultProducts];
  renderProductGrid();

  try {
    const res = await fetch('/api/products');
    if (res.ok) {
      const data = await res.json();
      if (data.products && Array.isArray(data.products) && data.products.length > 0) {
        allProducts = data.products;
        renderProductGrid();
      }
    }
  } catch {
    // Keep reserve catalog quietly
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
          <div class="flex items-center justify-between text-xs text-gray-400 font-mono mb-1">
            <span>SKU: ${p.sku}</span>
            <span class="${p.stock < 20 ? 'text-amber-600 font-bold' : 'text-emerald-600'}">${p.stock} in stock</span>
          </div>
          <h3 class="font-editorial text-xl font-bold text-charcoal group-hover:text-emerald-800 transition">${p.name}</h3>
          <p class="text-xs text-gray-500 mt-2 line-clamp-2 leading-relaxed">${p.description}</p>
        </div>

        <div class="pt-4 border-t border-gray-100 flex items-center justify-between">
          <div>
            <span class="text-[10px] text-gray-400 uppercase tracking-widest block font-mono">Price (Incl. Tax)</span>
            <span class="font-editorial text-2xl font-bold text-charcoal">₹${Number(p.price).toLocaleString('en-IN')}</span>
          </div>
          <button onclick="addToCart('${p.id}')" class="px-5 py-2.5 rounded-full bg-charcoal text-white hover:bg-black font-medium text-xs flex items-center gap-2 transition active:scale-95 shadow-sm">
            <i data-lucide="plus" class="w-4 h-4"></i>
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

function filterCategory(category) {
  selectedCategory = category;
  const pills = document.querySelectorAll('.category-pill');
  pills.forEach((btn) => {
    if (btn.textContent.trim().toLowerCase().includes(category.toLowerCase()) || (category === 'ALL' && btn.textContent.includes('All'))) {
      btn.className = 'category-pill px-4 py-1.5 rounded-full text-xs font-medium bg-charcoal text-white transition';
    } else {
      btn.className = 'category-pill px-4 py-1.5 rounded-full text-xs font-medium bg-white text-gray-700 border border-gray-200 hover:bg-gray-50 transition';
    }
  });
  renderProductGrid();
}

// ----------------------------------------------------------------------------
// 3. Shopping Cart Management & Secure Order Execution
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
    alert('Your bag is empty! Please select an artisanal item.');
    return;
  }

  const token = localStorage.getItem('ecom_token');

  // Security Gate: Customer must sign in before order placement
  if (!currentUser || !token) {
    toggleCartDrawer(false);
    openAuthModal('login');
    const subtitle = document.getElementById('authModalSubtitle');
    if (subtitle) subtitle.textContent = 'Please sign in or register to complete your order';
    return;
  }

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
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        items,
        shippingAddress: currentUser?.address || '12 MG Road, Mumbai, Maharashtra 400018',
        paymentMethod: 'UPI (Razorpay Gateway)',
      }),
    });

    const data = await res.json();
    if (!res.ok) {
      if (res.status === 401) {
        handleLogout();
        openAuthModal('login');
        throw new Error('Your session has expired. Please sign in again.');
      }
      throw new Error(data.error || 'Unable to complete order.');
    }

    cart = [];
    updateCartUI();
    toggleCartDrawer(false);

    alert(`🎉 Order Placed Successfully!\nOrder Number: ${data.orderNumber}\nAmount: ₹${Number(data.totalAmount).toLocaleString('en-IN')}\n\nA confirmation has been sent to your registered email.`);
  } catch (err) {
    alert(err.message || 'Unable to place order at this time.');
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
  const unauthenticatedNotice = document.getElementById('unauthenticatedNotice');
  const authenticatedSections = document.getElementById('authenticatedSections');

  const token = localStorage.getItem('ecom_token');

  // Security Gate: If not authenticated, lock privacy view
  if (!currentUser || !token) {
    if (unauthenticatedNotice) unauthenticatedNotice.classList.remove('hidden');
    if (authenticatedSections) authenticatedSections.classList.add('hidden');
    if (userEmailEl) userEmailEl.textContent = 'Guest Session';
    if (statusBadge) {
      statusBadge.textContent = 'NOT SIGNED IN';
      statusBadge.className = 'inline-block mt-2 text-[10px] font-bold font-mono px-2.5 py-0.5 rounded-full bg-gray-100 text-gray-700';
    }
    return;
  }

  // Authenticated State
  if (unauthenticatedNotice) unauthenticatedNotice.classList.add('hidden');
  if (authenticatedSections) authenticatedSections.classList.remove('hidden');

  if (userEmailEl) userEmailEl.textContent = currentUser.email;

  try {
    const res = await fetch('/api/privacy/status', {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (res.status === 401) {
      handleLogout();
      return;
    }

    const data = await res.json();

    if (data.status === 'SOFT_DELETED' || data.status === 'QUARANTINED') {
      if (statusBadge) {
        statusBadge.textContent = 'SCHEDULED FOR ERASURE';
        statusBadge.className = 'inline-block mt-2 text-[10px] font-bold font-mono px-2.5 py-0.5 rounded-full bg-red-100 text-red-800';
      }
      if (quarantineBanner) quarantineBanner.classList.remove('hidden');
    } else {
      if (statusBadge) {
        statusBadge.textContent = 'ACTIVE ACCOUNT';
        statusBadge.className = 'inline-block mt-2 text-[10px] font-bold font-mono px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800';
      }
      if (quarantineBanner) quarantineBanner.classList.add('hidden');
    }

    // Set toggle positions
    const mktConsent = data.consents?.find((c) => c.purposeId === 'marketing')?.isGranted ?? true;
    const anlConsent = data.consents?.find((c) => c.purposeId === 'analytics')?.isGranted ?? true;

    if (toggleMkt) {
      toggleMkt.disabled = false;
      toggleMkt.checked = mktConsent;
    }
    if (toggleAnl) {
      toggleAnl.disabled = false;
      toggleAnl.checked = anlConsent;
    }

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
  } catch {
    // Keep safe fallback state
  }
}

async function handleConsentToggle(purposeId, isGranted) {
  const token = localStorage.getItem('ecom_token');
  if (!currentUser || !token) {
    openAuthModal('login');
    return;
  }

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
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        purposeId,
        isGranted,
      }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed to update preferences');
  } catch (err) {
    alert(err.message || 'Could not update preferences');
    await initPrivacyCenter();
  }
}

function promptErasureModal() {
  const token = localStorage.getItem('ecom_token');
  if (!currentUser || !token) {
    openAuthModal('login');
    return;
  }
  if (erasureVerificationPending) {
    syncErasureOtpUi();
    document.getElementById('erasureOtpCode')?.focus();
    return;
  }
  const modal = document.getElementById('erasureModal');
  if (modal) modal.classList.remove('hidden');
}

function closeErasureModal() {
  const modal = document.getElementById('erasureModal');
  if (modal) modal.classList.add('hidden');
}

function restoreErasureOtpState() {
  try {
    const raw = sessionStorage.getItem(ERASURE_OTP_STORAGE_KEY);
    if (!raw) return;
    const saved = JSON.parse(raw);
    if (!saved?.pending) return;
    erasureVerificationPending = true;
    const message = document.getElementById('erasureOtpMessage');
    if (message && saved.message) message.textContent = saved.message;
  } catch {
    sessionStorage.removeItem(ERASURE_OTP_STORAGE_KEY);
  }
}

function persistErasureOtpState(message) {
  sessionStorage.setItem(ERASURE_OTP_STORAGE_KEY, JSON.stringify({
    pending: true,
    message: message || document.getElementById('erasureOtpMessage')?.textContent || '',
  }));
}

function clearErasureOtpState() {
  erasureVerificationPending = false;
  sessionStorage.removeItem(ERASURE_OTP_STORAGE_KEY);
  const otpInput = document.getElementById('erasureOtpCode');
  if (otpInput) otpInput.value = '';
  showErasureError('');
  syncErasureOtpUi();
}

function syncErasureOtpUi() {
  const otpForm = document.getElementById('erasureOtpForm');
  const requestActions = document.getElementById('erasureRequestActions');
  otpForm?.classList.toggle('hidden', !erasureVerificationPending);
  requestActions?.classList.toggle('hidden', erasureVerificationPending);
  closeErasureModal();
}

function cancelErasureVerification() {
  clearErasureOtpState();
}

async function executeAccountErasure() {
  if (erasureBusy || erasureVerificationPending) return;
  const token = localStorage.getItem('ecom_token');
  if (!currentUser || !token) {
    openAuthModal('login');
    return;
  }

  setErasureBusy(true);
  showErasureModalError('');
  try {
    const res = await fetch('/api/privacy/dsr/erasure', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        reason: 'Customer initiated Right to Erasure request',
      }),
    });

    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Erasure request failed');

    if (data.status !== 'VERIFICATION_REQUIRED') throw new Error('The portal did not start email verification.');
    erasureVerificationPending = true;
    const otpMessage = `${data.message} You can switch tabs to check your inbox; this form stays on the page.`;
    const message = document.getElementById('erasureOtpMessage');
    if (message) message.textContent = otpMessage;
    persistErasureOtpState(otpMessage);
    syncErasureOtpUi();
    document.getElementById('erasureOtpCode')?.focus();
  } catch (err) {
    showErasureModalError(err.message || 'Erasure request could not be started.');
  } finally {
    setErasureBusy(false);
  }
}

function setErasureBusy(busy) {
  erasureBusy = busy;
  for (const id of ['erasureStartButton', 'erasureVerifyButton']) {
    const button = document.getElementById(id);
    if (button) button.disabled = busy;
  }
}

function showErasureError(message) {
  const error = document.getElementById('erasureError');
  if (error) {
    error.textContent = message;
    error.classList.toggle('hidden', !message);
  }
}

function showErasureModalError(message) {
  const error = document.getElementById('erasureModalError');
  if (error) {
    error.textContent = message;
    error.classList.toggle('hidden', !message);
  }
}

async function verifyAccountErasure(event) {
  event.preventDefault();
  if (erasureBusy || !erasureVerificationPending) return;
  const token = localStorage.getItem('ecom_token');
  const code = document.getElementById('erasureOtpCode')?.value.trim();
  if (!currentUser || !token) { handleLogout(); openAuthModal('login'); return; }
  if (!/^\d{6}$/.test(code || '')) { showErasureError('Enter the six-digit verification code.'); return; }
  setErasureBusy(true);
  showErasureError('');
  try {
    const verification = await fetch('/api/privacy/dsr/verify', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ code }),
    });
    const result = await verification.json();
    if (!verification.ok || result.success !== true || !result.reference) throw new Error(result.error || 'Verification failed');
    clearErasureOtpState();
    handleLogout();
    let notice = document.getElementById('erasureSubmittedNotice');
    if (!notice) {
      notice = document.createElement('p');
      notice.id = 'erasureSubmittedNotice';
      notice.className = 'mx-auto my-4 max-w-3xl rounded-lg border border-green-200 bg-green-50 p-4 text-sm text-green-900';
      notice.setAttribute('role', 'status');
      const main = document.querySelector('main') || document.body;
      main.prepend(notice);
    }
    notice.textContent = `Your deletion request was submitted successfully. You have been signed out. Reference: ${result.reference}. Erasure completes after platform and agent processing.`;
  } catch (err) {
    showErasureError(err.message || 'Verification failed. Try again.');
  } finally {
    setErasureBusy(false);
  }
}

async function restoreAccount() {
  openAuthModal('login');
}
