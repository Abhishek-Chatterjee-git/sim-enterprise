-- ====================================================================
-- DPDPOS Enterprise E-Commerce Seed Dump
-- 1,000 Customers (with individual passwords), 100 Employees, Products
-- ====================================================================

BEGIN;


CREATE TABLE IF NOT EXISTS products (
  id VARCHAR(64) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  stock INTEGER NOT NULL,
  description TEXT NOT NULL,
  emoji VARCHAR(32) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(64) PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  phone VARCHAR(32) NOT NULL,
  aadhaar_no VARCHAR(32),
  pan_no VARCHAR(32),
  street_address TEXT,
  city VARCHAR(100),
  consent_purposes TEXT NOT NULL DEFAULT '["essential"]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS customer_credentials (
  user_id VARCHAR(64) PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  password_hash VARCHAR(255) NOT NULL,
  salt VARCHAR(255) NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
  id VARCHAR(64) PRIMARY KEY,
  user_id VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  items TEXT NOT NULL,
  total_amount NUMERIC(10,2) NOT NULL,
  shipping_address TEXT NOT NULL,
  status VARCHAR(64) NOT NULL DEFAULT 'CONFIRMED',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS employees (
  id VARCHAR(64) PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  department VARCHAR(100) NOT NULL,
  role VARCHAR(100) NOT NULL,
  salary NUMERIC(12,2) NOT NULL,
  pan_no VARCHAR(32) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS admin_credentials (
  employee_id VARCHAR(64) PRIMARY KEY REFERENCES employees(id) ON DELETE CASCADE,
  password_hash VARCHAR(255) NOT NULL,
  salt VARCHAR(255) NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


INSERT INTO products (id, title, category, price, stock, description, emoji, created_at) VALUES
('prod_vase_01', 'Hand-thrown Terracotta Indigo Vase', 'Home & Living', 2499.00, 25, 'Sculpted by master potters from Jaipur using organic earthen clay and natural botanical indigo glaze.', '🏺', NOW()),
('prod_mug_02', 'Wabi-Sabi Ceramic Teaware (Set of 2)', 'Kitchen & Dining', 1499.00, 40, 'Double-fired stoneware mugs featuring unique reactive glaze finishes. Microwave and dishwasher safe.', '🍵', NOW()),
('prod_blanket_03', 'Pure Cashmere Organic Throw Blanket', 'Textiles & Apparel', 4999.00, 18, 'Hand-loomed in the Himalayan valleys from ethically gathered grade-A mountain cashmere wool.', '🧣', NOW()),
('prod_lamp_04', 'Hammered Brass Moroccan Table Lantern', 'Lighting & Decor', 3299.00, 30, 'Intricately perforated brass casing creates warm, mesmerizing ambient geometric shadow projections.', '🏮', NOW()),
('prod_incense_05', 'Handmade Mysore Sandalwood Incense & Burner', 'Aromatherapy', 899.00, 50, 'Traditional temple-grade organic sandalwood rolled in aged vetiver root and natural tree resins.', '🪔', NOW())
ON CONFLICT (id) DO UPDATE SET stock = EXCLUDED.stock, price = EXCLUDED.price;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_admin_01', 'Rajesh Kumar (Store Manager)', 'admin@artisan-crafts.in', 'Operations', 'STORE_MANAGER', 85000, 'ABCDE1234F', NOW())
ON CONFLICT (email) DO NOTHING;

INSERT INTO admin_credentials (employee_id, password_hash, salt, updated_at)
VALUES ('emp_admin_01', 'ed68ffa40f018d673243c10a88b58cd25bef419818fd8d06a31f2054bd22b770', '441a6fe7a8469cfc683246d4598756ac', NOW())
ON CONFLICT (employee_id) DO NOTHING;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c2fa82d38b8e', 'pallavi.dubey1@example.in', 'Pallavi Dubey', '+919775947976', '8173-8708-6544', 'KVUPA3907K', '164, FC Road, Sector 34', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.164Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c2fa82d38b8e', 'd1a08f90f85e50edd450a2836b37246c2cfd982e57a8125b91da28d3a5b1fccb', '46fca1275df7007c260d43e582232cae', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a77aa1782053', 'rohan.pillai2@example.in', 'Rohan Pillai', '+917741973034', '2584-7364-7164', 'NIXPT0274T', '795, Anna Salai, Sector 43', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a77aa1782053', '1d0016e3b461ecf21efd404b1ab1ea4b85899fbc8eb4f0c598b3d9c0d2747315', '7440d535fc6c55d477533c188040504b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c94f2a5d03d4', 'aditya.menon3@example.in', 'Aditya Menon', '+917296745159', '7689-1173-9343', 'JFNPN4940D', '516, Indiranagar, Sector 38', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-01T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c94f2a5d03d4', '6fd5ab45d8e8d280a31582f5019d832f199b37031710b99bd37f0c30e2c27f7f', 'b3337330b5744174097aad1f59955fcb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ef0f27a70dde', 'aditya.malhotra4@example.in', 'Aditya Malhotra', '+918231357925', '2023-1548-9332', 'ADYPF7685W', '571, Banjara Hills, Sector 31', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-16T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ef0f27a70dde', 'd6eb29a105423d2b7ca823f805b7a153cb08ed816d36f223cfb78e2da76faea6', 'f3e9e2024aa692f2c9b85f67139df5fd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_713b77d33d02', 'ritika.verma5@example.in', 'Ritika Verma', '+918289800671', '2061-3137-1235', 'QONPQ4263M', '907, Brigade Road, Sector 30', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-12T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_713b77d33d02', '8b9fba2e074d267bf707ad540064c050d337ab25abbe962781358083dda012c3', 'b1627cadcff173cd1b8d0eb94fb7b090', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a21cf0cfb2d7', 'manish.chatterjee6@example.in', 'Manish Chatterjee', '+917266106690', '6928-6457-4460', 'VYBPX9395Y', '627, M.G. Road, Sector 43', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a21cf0cfb2d7', '37826dc056c49aa39c6ce44c33a81761c2b07e51590c0b1ed066887d185b1b2a', '754e356da7f6e1de68d8bfb5d7425fa2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9fa823a35d03', 'abhishek.joshi7@example.in', 'Abhishek Joshi', '+919893442426', '5534-1657-9469', 'ATYPC3322V', '645, Sector 17, Sector 29', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9fa823a35d03', '70999f0bca4ab0ac50b143d6b69931a6073e97a7a397ba4359764604abca32d8', '20defd767b5bdeb9607374adc7bf31de', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_849497e377b8', 'neha.patel8@example.in', 'Neha Patel', '+918871978450', '4157-4514-1989', 'UBVPQ6715P', '812, MI Road, Sector 22', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-13T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_849497e377b8', '38d8e8b65a75581ca03a3fa96fac99a35deb9a2433b7abe47a6ffa64fd5d5503', '9f84b95136cbd058bc1faf19700667f6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_92a9028d3ac2', 'shweta.bhatia9@example.in', 'Shweta Bhatia', '+917120443631', '6956-4484-2095', 'VGBPA4185D', '18, Anna Salai, Sector 8', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-23T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_92a9028d3ac2', 'da0226364e111e1548a7c9c2901f789e1426c1f88161f0a160e8fc06be2bf1c6', 'dffc0d282e0b887facbe63fb5c59fdc4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e33c89e2cfde', 'bhavna.saxena10@example.in', 'Bhavna Saxena', '+919593770920', '6229-9324-8374', 'NJHPC5932Y', '769, Indiranagar, Sector 6', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-30T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e33c89e2cfde', '5636f1b7c0cb1ec6e8c34e8bf2a18030e3124d321815bb7eedc2d27ab10b1217', '3106387246833f056fd055463ff9be9c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_59d974723b0a', 'manish.pandey11@example.in', 'Manish Pandey', '+917541563012', '9444-1923-1859', 'CBIPL2237E', '920, Banjara Hills, Sector 25', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-22T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_59d974723b0a', '15924efc2cc99ea05cc4b3dd446fe1cd0b23c2bddb40a27ae8f29ff3b7ebf4a2', '5509cc59652e37af1169391abbacfd41', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_63da043f20d3', 'alok.reddy12@example.in', 'Alok Reddy', '+919407402886', '7688-8004-1986', 'JKAPU1044Q', '135, FC Road, Sector 30', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_63da043f20d3', '42d8b95396e47878be4328efc65b7f94c2ea05ee6fb4a05e188339a9f48dde63', '71035284e59d011c73d7db3a2c2f92ef', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e3ca015ddec0', 'sneha.patel13@example.in', 'Sneha Patel', '+918942669554', '5822-3819-6715', 'THXPP6399D', '659, Koramangala, Sector 33', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-01T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e3ca015ddec0', '76f8981464f95494ed5fc64f49bae34a0750bf4d035574bb4eb0475cb8c6912e', '1d4fd0b7ff257bc0ccec4c4878bcf5a3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_612484f876c9', 'ritika.mishra14@example.in', 'Ritika Mishra', '+918186254877', '4187-6925-9746', 'VXLPJ9694T', '959, Sector 17, Sector 31', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-03T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_612484f876c9', '78a92143e16581d2aa1deb77a8e1f478d2bfb4e91817b92774984dde78d19101', '536fa43dd8fe5b791fadeab77bfcf903', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a821a7a4dbe0', 'vikram.bose15@example.in', 'Vikram Bose', '+919602780903', '7815-4759-5317', 'SDZPG3013E', '63, Koramangala, Sector 11', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-05T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a821a7a4dbe0', '98d98fbf0e12d9b3646957d40b981195ea8dd4768260cb9aa7152c34e52cb67e', 'e2173fc61db07a9888a019d4dd860213', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_913c68c3a3b7', 'aditya.saxena16@example.in', 'Aditya Saxena', '+917803236186', '3752-3389-4449', 'SFOPR3169Q', '788, Sector 17, Sector 26', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_913c68c3a3b7', '483378fb62ecab538e22073c5d61a0f0ec18f95195e85c0e2e74d8b958e49f40', '08d4676688a30600af2029ff0f6e5f73', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5d763ac67a03', 'vikram.pandey17@example.in', 'Vikram Pandey', '+919279582371', '4285-1034-8663', 'YEIPH2983P', '128, M.G. Road, Sector 17', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5d763ac67a03', '642c6f0b8594d0b1e671a09708ee7782362faa1ef9f35b2b7aae490033e98923', '30fce1007aa5cdd6208576610d77e8a1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ee1ad8822e30', 'kunal.menon18@example.in', 'Kunal Menon', '+917938749400', '5020-1709-1334', 'LVOPW7958K', '907, Sector 17, Sector 34', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ee1ad8822e30', '475753fa95511ee8c62598e8cd94246107dd7db312c21f1d43835c7e92b8ba5e', 'e5d99c87682f65f24a6304f1139277f7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4ca42f29c3e6', 'varun.pillai19@example.in', 'Varun Pillai', '+919379409486', '5879-4499-1888', 'TPTPX5358F', '818, Anna Salai, Sector 6', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-31T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4ca42f29c3e6', '6cc286c35157fb09e7fc24cda8ae694708413f07567f24d627ee0480333af421', 'ccfa53bb085367d6b528ee506d23e152', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_96a0abb6b662', 'anjali.iyer20@example.in', 'Anjali Iyer', '+918740997518', '7939-3092-3450', 'GBTPY6814X', '275, Connaught Place, Sector 38', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-15T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_96a0abb6b662', '96d576faf0383d21796e9889be977474df6c3ffd94ff59de7d4f55d90404cdaa', '412772c4eacfe9efcb26711bfefcb1c4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5ad3d81d7040', 'varun.chatterjee21@example.in', 'Varun Chatterjee', '+918852073160', '9079-3498-2915', 'TPYPY7639L', '374, FC Road, Sector 6', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-17T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5ad3d81d7040', '32598fdfdf6f50f6b4378266eb2459d1d5a7c7b9283c31286f62eebb438df1d7', 'f6818905404cd6a130d28c11ff54a459', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6d796c607791', 'rahul.gupta22@example.in', 'Rahul Gupta', '+918925272517', '8013-1752-6733', 'OYEPK4741G', '474, M.G. Road, Sector 13', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6d796c607791', '14e2489e65f169fafd4f0cbac594da1ecce5810ee1473e0a69d459710bc159b1', '0571bc650a8f97cb796e5b1120b079aa', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2d0ded833c26', 'karan.bose23@example.in', 'Karan Bose', '+917176023775', '2737-9586-1470', 'IFAPR5452O', '290, Banjara Hills, Sector 17', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2d0ded833c26', '24c8a8f1d47a291abe795304b1ef5ec18a2483dc1f415af58a922a58997f3c5b', '2f7461943563e64339fd7973ca31d6c0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6389b5c8f068', 'nikhil.joshi24@example.in', 'Nikhil Joshi', '+917583450872', '9729-2495-5513', 'VBKPA4692M', '91, M.G. Road, Sector 3', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-03T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6389b5c8f068', 'b205c650d79578e1ccdc3f115551e9f80bf347968620bc1c3e4023d43fc30ffd', '487ea637c78d2f4e59039bc388e84b54', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_02ea3e7cbca4', 'manish.mishra25@example.in', 'Manish Mishra', '+918812793442', '6633-7065-2898', 'OMXPW2373A', '593, Brigade Road, Sector 3', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-14T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_02ea3e7cbca4', '56003352f9c51cc2e3b0edf2a3f532f7e9b5fa6c704bcbdd55b4caca7e6930c3', '54151a63a70cc366143c4747496686a5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7cae114162e8', 'shweta.chatterjee26@example.in', 'Shweta Chatterjee', '+917926982565', '2251-5344-2815', 'DZXPA1051X', '128, Koramangala, Sector 22', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-01T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7cae114162e8', '6d73f0eb5b8ebb8c9df695784a639669d2ac56a3498dbb9591ad11bbc31092ed', 'f9017d723eff581790f6f7caba8f1e2f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8465a58947e2', 'nikhil.mishra27@example.in', 'Nikhil Mishra', '+919577680152', '8536-4035-2624', 'CRTPR4462A', '893, SG Highway, Sector 28', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8465a58947e2', '891aa2e69c45155d9a74b8d1adf5283e7c56db0b6076d6120ea65f1064c40ad4', '5b66ba54dd960028b91561949ac91f5f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e665fe03e7a8', 'sneha.sharma28@example.in', 'Sneha Sharma', '+917404932411', '4321-2343-6531', 'GGFPN9966T', '732, Connaught Place, Sector 15', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e665fe03e7a8', 'caa4fc9ad797a1520d116b466a8022beb9641b536332ae19010de01768991b50', 'c2b13f3a999702fa1bfbf68500247907', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a4b50c8aa363', 'priya.chopra29@example.in', 'Priya Chopra', '+919920936565', '6652-1509-5163', 'CXHPO0195T', '649, Anna Salai, Sector 13', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-14T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a4b50c8aa363', '23af33cdb20539dca93f6e197ed429237bcad502e0c924b5405e4d6773a5a2fc', 'c26d138aa3b640c2013a79e6b6c977b6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d67ee45dce03', 'arjun.kumar30@example.in', 'Arjun Kumar', '+917293428705', '3740-2258-5507', 'PVAPM8647E', '268, Brigade Road, Sector 6', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d67ee45dce03', 'eff6527e69cc54a2d6aa084de6a7e358e5ea6ba690bc773db7a3145ab62985e3', '879374ea0a859231b473dd9ecd35a736', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ab8c5f0a23f8', 'nikhil.pillai31@example.in', 'Nikhil Pillai', '+918661756205', '4129-7382-6351', 'GBEPG5629W', '198, MI Road, Sector 45', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-17T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ab8c5f0a23f8', '66408108db8ca076d8f71eb049a0be7305aca949c90fd2e1ff91ff90b7dffaab', 'f8d6bc98b1d0eec854282f399350c923', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df953e8d7bd9', 'ritika.menon32@example.in', 'Ritika Menon', '+917791906863', '6585-3593-6757', 'FCJPP4181D', '376, M.G. Road, Sector 28', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-27T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df953e8d7bd9', 'a799a145a679608a2457cccf1026c3e0ed769afd4da5dbda5701acf4de6c94ab', 'f34669839dd6f700a19c3842480912d7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ecaf5312444a', 'swati.chopra33@example.in', 'Swati Chopra', '+919292058481', '5433-3307-1966', 'BRXPX7490G', '923, Brigade Road, Sector 8', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ecaf5312444a', '71668f88d4b477c62dd579abf4d65546cff8b9614924fe4a9b64ae4560f34bab', 'a642b17845b488678d9bbbe575614cf5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e47cdea9567f', 'kavita.deshmukh34@example.in', 'Kavita Deshmukh', '+917922662856', '2909-8294-5444', 'FZQPS9278J', '569, Park Street, Sector 45', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-16T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e47cdea9567f', 'e4023315ebe2c40dc65f1debc6104bae93b1cad3a9bffe28c5e008777db2e2c9', '56a532d5db56956914c24a3612841fe0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_eec6f15c2f5c', 'sunita.agarwal35@example.in', 'Sunita Agarwal', '+919339996567', '9054-7674-8148', 'QRYPZ6927K', '189, Brigade Road, Sector 16', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_eec6f15c2f5c', '9fe6f875b24e2531661105167a99d294755d5a6fa879b4351552c4b81fbd6e61', '0731f54eeedc740d14d0b1c115ecc424', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_805b1f221877', 'aarav.kapoor36@example.in', 'Aarav Kapoor', '+917418552211', '8506-4864-2758', 'OGMPX7535M', '899, Banjara Hills, Sector 22', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-28T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_805b1f221877', 'bfad7b66c657ef4d660e4fde4956d80146e597cc25d412ea0df0ea8bc48943da', 'ea8059d464bab630d883cb761a39fa96', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9334f125e706', 'kavita.trivedi37@example.in', 'Kavita Trivedi', '+918479553279', '2559-1892-1006', 'IUDPO5842F', '478, Anna Salai, Sector 45', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-23T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9334f125e706', 'd2495cca80032dacc49dfdc2cb3c4e568ffe0b3445c0a2f4fbf86f3a941d95c5', '6b07e3166085c66e5742c2587fe28789', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_70f5c9fb0f8f', 'karan.gupta38@example.in', 'Karan Gupta', '+919674059920', '3905-3225-7425', 'PUEPH8357B', '911, Anna Salai, Sector 39', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-14T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_70f5c9fb0f8f', 'dc42ac3c07352e829fb9f67e227bcb20e55d9c0fb560a758ce55816765ecc8ec', '5939d4e03e54dcef598ce3fb789af8c3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d8dd5aa09705', 'ritu.bhattacharya39@example.in', 'Ritu Bhattacharya', '+917445460860', '8826-5155-9660', 'JSYPG8834W', '758, SG Highway, Sector 4', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-01T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d8dd5aa09705', '132557517855f791abf0d0a498339c639f5ab115061cc48110f40061b175c4bd', '4716c375fd1020fc1b808c503272ce16', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1de340cc29a3', 'rohan.deshmukh40@example.in', 'Rohan Deshmukh', '+917739000349', '5124-4028-6988', 'OFJPJ1840U', '217, SG Highway, Sector 38', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1de340cc29a3', '90d96faba3cabd1d11d2f07a7bd183099d7bdfb78332f5178a86e622ace57167', '2288e04d50d494c4e23add87da531202', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1cd1834a227b', 'gaurav.kumar41@example.in', 'Gaurav Kumar', '+918476289265', '2652-3873-1907', 'TZAPH0018C', '440, SG Highway, Sector 13', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1cd1834a227b', '01c43be518c108588814d3b666ade00033b91e14365de68fc7cc80bd71c69e47', '56ec61666b1cac8d42e3e93e5df51250', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_59b2e7734a04', 'abhishek.kumar42@example.in', 'Abhishek Kumar', '+918188555332', '9963-2215-4904', 'QSEPA1383X', '944, Park Street, Sector 21', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_59b2e7734a04', '3e5a016650b5d02a6532b833c98f7aad34287e5d591503d86a3df3df6676f803', '5e2d9f7ca569dcb7ac1e6d7d2232d706', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d67c2db565a9', 'nikhil.menon43@example.in', 'Nikhil Menon', '+919677336334', '6041-3963-9865', 'FJNPP6901Y', '335, Connaught Place, Sector 43', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-11T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d67c2db565a9', 'a644ddca1af3a7ebd73475710f1f75f56f4e5add6c4b4fd8551b89a2321cb5dd', '8218ea5c9c12b085c5faecaf39f03f3b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_14d5df1840d1', 'sunita.kulkarni44@example.in', 'Sunita Kulkarni', '+917516891119', '3349-5055-5187', 'GNIPS4259I', '537, M.G. Road, Sector 44', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-10T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_14d5df1840d1', '0095af8e44d73eda6e4e1e09e60fd3a5863dd65dd1cafa0d96739e6df79b24f7', '687ab83cda9a7f77ef08755307cdf939', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e577ae6af0b7', 'karan.mehta45@example.in', 'Karan Mehta', '+919711166755', '5046-7644-4840', 'AILPY9329C', '296, MI Road, Sector 20', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-15T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e577ae6af0b7', '245c35f9ebd69546f4b0174d53d5d66c25ba7229095ef8d364ce1f999a912338', '323d5322464e1b0f80aa71b27c6be20a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ae35e4fca433', 'siddharth.kulkarni46@example.in', 'Siddharth Kulkarni', '+917230857115', '3865-3242-4116', 'YZOPT4799D', '99, Park Street, Sector 25', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-17T10:59:26.165Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ae35e4fca433', '562769f516115168def0a2730c157a5e1c39a14166bfaeab124fab1f264bb2ed', '26e8a3c55f1a30423b1159b5d3ac30be', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3719ccabc500', 'anjali.verma47@example.in', 'Anjali Verma', '+917225839104', '4130-4340-8018', 'AFNPO9561R', '893, MI Road, Sector 7', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3719ccabc500', 'ffdadeb033ccca6550ffb4e9788377a7b0b9b28420acb2f56fdb8c51545b3ea0', 'e6a22d4f59db1239b1378ee6ebc439b8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9cb8b358c2e6', 'neha.deshmukh48@example.in', 'Neha Deshmukh', '+918236250097', '2806-6683-6003', 'OPYPX4206D', '523, Sector 17, Sector 34', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9cb8b358c2e6', '7f5895761c5322a9f46a964dcb0223a15c3f0b34712e3b6dc0d83b4620f7cb9c', 'd6e7c5fe62fa8a4d0ec95c1cc001139b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a78e5d50aabc', 'anjali.trivedi49@example.in', 'Anjali Trivedi', '+917658011738', '5527-9876-8536', 'NGOPV1155Q', '913, MI Road, Sector 31', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-17T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a78e5d50aabc', 'eadf2050a76043a4a81de6a80d60bfe5479aabcfbbd26af31cac560e1af9ce06', 'd8b26acfb4f68341e290a41d4718d5d2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e53f40395054', 'dev.sharma50@example.in', 'Dev Sharma', '+919574648888', '3182-6517-9338', 'FWWPZ4962U', '735, Connaught Place, Sector 40', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-02T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e53f40395054', 'dbe10f96fa2650a513d464387a75519884aca63c4b60e34b1ef0cce9f6748c31', '751e4ed91535fb9d93cd57504e4ea844', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_78499ab356c6', 'shweta.trivedi51@example.in', 'Shweta Trivedi', '+918217569531', '8734-8443-5725', 'VWUPX1608D', '527, Brigade Road, Sector 42', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-08T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_78499ab356c6', '71a29a530bdc4f80909261be163fcb192c24d45cd7fffb2b44e95e157fad8ca4', 'e2bca7612217064b56e1975fff33d625', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8df371864b46', 'kavita.sharma52@example.in', 'Kavita Sharma', '+918638804161', '9713-1293-8297', 'KGEPN1871S', '371, Anna Salai, Sector 23', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-28T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8df371864b46', 'c0b97ad6c36f4c9c2fb714faafa39dc3d4c7a8856adac7e75f4b93f3a8604932', 'ded561889d3d1a8167ce67df869e2e03', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1bb25c2e2ea9', 'dev.mukherjee53@example.in', 'Dev Mukherjee', '+917414326815', '2674-8635-4042', 'UYRPB9193N', '380, Sector 17, Sector 44', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-16T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1bb25c2e2ea9', 'dd9f7f571da60bb97612309d265e50401f1752ee95e64d6f358edc3396e83d0c', 'c7776e013ab92023dd5946e9b55162f4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7d6f60a03c11', 'abhishek.reddy54@example.in', 'Abhishek Reddy', '+917853349100', '8819-7540-8854', 'UWFPH5436T', '333, Anna Salai, Sector 23', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7d6f60a03c11', '79412e2421ebefec4d84279fda0c188b2b41474b5710101a7345f3ff31a07478', 'b7b132eba58ae86089dcf30bc8bbb7e5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fce5d2c018aa', 'deepika.nair55@example.in', 'Deepika Nair', '+919498903696', '3452-7549-5367', 'RNQPD6297Y', '647, Koramangala, Sector 29', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-26T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fce5d2c018aa', '56aa24615fcbda5195f1dae1f0d38832d3ece947bbf8dda4796cc7b148877aa7', '7dacb79f3e1f233d15ce9ce660c07bf9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b7a0874366e5', 'kunal.iyer56@example.in', 'Kunal Iyer', '+918194294296', '4044-9137-6301', 'POFPL8592X', '382, MI Road, Sector 9', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b7a0874366e5', '18125240804aa1c2bd89cd8ebba41d34d82a08ac60ee3379eb8fe72f769da21d', 'e468614305bcd2e18fc18f4524449291', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e97725e452c6', 'amit.iyer57@example.in', 'Amit Iyer', '+918269326836', '4188-8582-4081', 'BDPPD2283N', '780, MI Road, Sector 37', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-28T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e97725e452c6', '097c33fd3bf69110c24256c271607bc0c0c9ab76276d253fb3ddf9e3e86c9573', '02616dbba1b7f9dca2f3631ef6ef65ee', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_43167172928c', 'siddharth.kulkarni58@example.in', 'Siddharth Kulkarni', '+917353063717', '3161-9718-2955', 'QCPPV8830D', '638, Koramangala, Sector 28', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_43167172928c', '5d6f92759cf77a506041362fc9d9f035b364e4296ab6fb80acb9b10158197028', '3ea79609ee33058569c295813174d5b9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_40b1af4128ed', 'varun.bhatia59@example.in', 'Varun Bhatia', '+918996160377', '5356-9255-7427', 'PVPPL4107W', '539, M.G. Road, Sector 24', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_40b1af4128ed', 'f7de2e71417a15431bf422c7280df8bd8af196234b0465aa7459f99cf4171db9', 'd90f345dd994031ee4ce83687a9d8d68', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_57b755e66847', 'dev.chatterjee60@example.in', 'Dev Chatterjee', '+918501559034', '3612-4479-5099', 'PCMPD2785U', '677, MI Road, Sector 17', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_57b755e66847', '7983780d3e929079f9529e13291362a80a4d1688a70112e9a971e24f62682225', 'a841f9143cf0ad358220c910bc9d2006', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b2d1ae0eae21', 'simran.bhatia61@example.in', 'Simran Bhatia', '+917229640756', '2937-4363-7135', 'DMAPJ0614C', '947, Sector 17, Sector 20', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-13T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b2d1ae0eae21', 'a6938c00c9f2333291e2b2ffe92c1b9f153d8e2f7f0a1c93f404618d1c13c9b4', '1f64ed1e942f822bfd361394f8967b82', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0331541adb33', 'ananya.joshi62@example.in', 'Ananya Joshi', '+917845733779', '3728-1282-1541', 'NAMPV0439E', '811, Connaught Place, Sector 34', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0331541adb33', '5de5b36f0ea8d976c69fe4b40322e2ed7e42a954f4e3f55e8bd66fc9fdb45f62', '73f2e34491c4980aa1b44ce3a89793a7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_af8c8cc4e335', 'nikhil.dubey63@example.in', 'Nikhil Dubey', '+919903606446', '8944-1195-4624', 'NABPQ7160C', '12, Anna Salai, Sector 43', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-28T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_af8c8cc4e335', '88aaf96c84fcd3b0e18466effdd333599ebec38121ab8ea39d610a8f0ec035bb', 'f8c198da45c124205e893b7a2168f79d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4f6b595aa9c8', 'priya.gupta64@example.in', 'Priya Gupta', '+919948319662', '8358-2980-7259', 'HZFPS7766R', '600, Sector 17, Sector 17', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4f6b595aa9c8', '78ea6f923d1bb9e2dbfab780167ff82f02e2d378f657d1b0f7a370752bd60a80', '7e81d2ad27f83896e347f7e04cedfa43', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1bbe34eb3815', 'arjun.iyer65@example.in', 'Arjun Iyer', '+919929984629', '4557-3971-7867', 'ABTPQ1916X', '977, Brigade Road, Sector 9', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-11T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1bbe34eb3815', '39c8f228b79d1b5d60aeea895a226e265c66203530c1669593e942004c710d0b', '4ced1d73f7eccc4ccabfe9a0adafb02a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8dbd578f624f', 'anjali.chauhan66@example.in', 'Anjali Chauhan', '+919289702995', '7820-9434-6310', 'YBQPN6379O', '663, FC Road, Sector 3', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8dbd578f624f', 'c95e96a30f7d60627593d11157953120595b430af726cccbfac9ebefef4797b9', '38f4987c4495725172489e99ceaab3d6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8b8bef51400b', 'divya.malhotra67@example.in', 'Divya Malhotra', '+917639042336', '4940-9887-5278', 'AZYPM5626S', '605, Koramangala, Sector 28', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-15T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8b8bef51400b', '50e1de80967be845b9f52dfe1e83293866dcc3723aa7ffd1658ddc2786caae42', 'ebdba1a0d2540fd2743a2daaa8d797c6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_209c267b9075', 'gaurav.kumar68@example.in', 'Gaurav Kumar', '+919620274851', '2792-9438-5322', 'EQPPQ8511X', '707, FC Road, Sector 6', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_209c267b9075', '0f2f0382e1adab6e5c1f637072a45d686015b14851de380ac6f4c0a03efa80e9', '664a8c4aea4c22b2c44f91e17783967d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1ea29810f013', 'rahul.bhatia69@example.in', 'Rahul Bhatia', '+918168145291', '7472-8948-7470', 'WQOPX8164L', '84, SG Highway, Sector 14', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-28T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1ea29810f013', '72e54726819216dde09fa39afb90612fbf190975e4e0d868a9cd2005bd3ee1cf', '3b5d7bc61473962be08ff22bf7837e09', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_86af080d5a67', 'nikhil.kulkarni70@example.in', 'Nikhil Kulkarni', '+918228726703', '7453-3942-6858', 'MHQPQ0523N', '747, M.G. Road, Sector 22', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-02T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_86af080d5a67', '0d8532d0ad70194ddab30741f025106b09c0de978a8bfb796ff37c53847b4283', '59476ad548105647ac99d31b4ec2840e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5b3200e6c549', 'kunal.agarwal71@example.in', 'Kunal Agarwal', '+917841789912', '3996-6965-6591', 'PKUPR3645N', '4, Sector 17, Sector 2', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5b3200e6c549', '26a90ef38850c26dec57a2733d72187f2ba7bb88ed515b70e554ff6dee5f704b', '1fb3fe4c858bb0cd2bf94303eb3277fb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d32b5fe94e7f', 'sneha.trivedi72@example.in', 'Sneha Trivedi', '+917580636781', '5927-9122-3765', 'KXAPS5593H', '167, FC Road, Sector 22', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-04T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d32b5fe94e7f', 'fc5b1be95cd68639493df4e0974aa75d74d1673bb1acfa1da6d5a9f599bc6f56', 'dae19fdedc69db7518f232c39480d3f8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2e8f952d5dca', 'divya.menon73@example.in', 'Divya Menon', '+917697313573', '5674-1865-1879', 'WMAPQ7486Y', '326, Sector 17, Sector 36', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-18T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2e8f952d5dca', '79958856f4e0532376f60017b9f9838240e97a2293d1990d7dc48b824f0bb142', 'c2d28b7002c271e6dddfb326eeff9d13', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0d60e5e7cd00', 'anjali.bose74@example.in', 'Anjali Bose', '+918962784065', '2147-7911-2023', 'DLEPJ9648A', '935, Banjara Hills, Sector 38', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0d60e5e7cd00', '44faedb92d4dd3e2f3d23ff4d00260ec27ff0891e3aaf265233b8083fcf9f035', 'a3674fdd54aeb7fccb8007afc5ad2b9e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9b181a1b8210', 'ritu.iyer75@example.in', 'Ritu Iyer', '+917178821019', '3797-9282-6701', 'YWZPP0055Y', '392, M.G. Road, Sector 39', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9b181a1b8210', '0d55c29b818b78147ccf02ebcefbea7eaafebd1858f9d438047baab92ac63a94', '0fef63fb315424bb52f9a1bb4171015c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_105ddc3a30a3', 'nikhil.kapoor76@example.in', 'Nikhil Kapoor', '+919737963277', '2857-4099-5253', 'IHLPC6302K', '539, Banjara Hills, Sector 10', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-23T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_105ddc3a30a3', 'aa342b17c935f2e6410dfd4a9489d82ea9b9f362e46c36b7c876ba396e3fe0e0', '01e03f1ff0327decf9cdaad2ac12088c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e3f54b77376a', 'meera.kulkarni77@example.in', 'Meera Kulkarni', '+917467516898', '7943-5147-8855', 'TERPC3401L', '336, Banjara Hills, Sector 26', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-28T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e3f54b77376a', 'b4c514efc0c7ec4388ff5a889a9962aa53861ac8dc2c5149c919508c60b12cd9', '3ed7546665d0f12edf63e574d6a7447f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_297f0b3724b1', 'sanjay.agarwal78@example.in', 'Sanjay Agarwal', '+919428703438', '7790-6456-9353', 'HLDPE1201H', '654, SG Highway, Sector 17', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-11T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_297f0b3724b1', '1c56227c6ea24e3ba85f30b43ab4cce7aacbec85ac0befd437b3b6c2129cbcae', 'd0749da937567891483669031ae9896a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_acb6b06b255f', 'aarav.joshi79@example.in', 'Aarav Joshi', '+919284198550', '7785-8224-5128', 'WGDPK0582J', '824, SG Highway, Sector 23', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-14T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_acb6b06b255f', '00153baaa6a8e93fc152ccf3134a950e20edb1ca8e00feeb8b1142b556f3f4b2', 'ee364d69d307898d1885e0834c03d140', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_806389048f35', 'manish.mishra80@example.in', 'Manish Mishra', '+919937593555', '2082-9979-4648', 'XXYPP0412E', '353, Park Street, Sector 17', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_806389048f35', '688fa25018587cc933f878b2124183b63959a0288ee27b0ec1fd8e13909e7acc', 'c217e42387a3fb6bcddb92c74fd637fb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dcc8349df29c', 'shweta.deshmukh81@example.in', 'Shweta Deshmukh', '+917239239846', '6321-6117-1298', 'QKMPM6801C', '868, MI Road, Sector 12', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dcc8349df29c', 'a641b0266e1651875b9a4a61df9ca3c2df62a72889a7cd47aab521cc538a3e68', '6c2f26b91e15904a6bd0698264eff027', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0a74db18f258', 'tanvi.malhotra82@example.in', 'Tanvi Malhotra', '+918939805621', '6798-5553-4383', 'MTRPI6274S', '382, Park Street, Sector 39', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-26T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0a74db18f258', '0a38f857dab89aeec2b2cd44d98a6db0d8c00238cd6f0da5366572b4325e6d90', '1d90ca5b3e8ee76a7b7de6eb936b6883', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_908548fbc76d', 'ritika.kumar83@example.in', 'Ritika Kumar', '+918167138509', '7756-4138-4293', 'TYJPM8049N', '365, SG Highway, Sector 24', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-23T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_908548fbc76d', '556376f1edced152ecea1a813f9a7c025c763505a41e32c0a91fff6f14a2ab5d', '9b2c8b0a61e0ad6fd6473a16169fb219', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c9a6108ded2f', 'rohan.sharma84@example.in', 'Rohan Sharma', '+918661754764', '3969-1580-7970', 'JDRPK2667D', '457, M.G. Road, Sector 34', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-18T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c9a6108ded2f', '2fe402b315ac0d741b7a5af801bb3f0a5890fea951246379730b2449f07fb5fd', '62ec6d169d4aadc721c2ae0353b9c3b5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6d918fc69536', 'dev.patel85@example.in', 'Dev Patel', '+919596403209', '6997-4120-6840', 'NEKPZ8689G', '680, Sector 17, Sector 11', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-30T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6d918fc69536', 'bf690681ee94d0eb8deb19f380072d938f1c512b6c42162b296cb3987f0c5da7', '70ca6a6f3cf3ce1e43e1ab7f732d306e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_69c573921d1a', 'karan.joshi86@example.in', 'Karan Joshi', '+919903859777', '8911-7180-2877', 'QXJPK4028H', '270, Koramangala, Sector 39', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_69c573921d1a', '4726dcf70f39e5bb0dd267199c196d25b777c1a405aaa7e888dff6375851ec57', '96d65b40f8520ff5249a312b9cb6cd18', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_820e76299cde', 'manish.pandey87@example.in', 'Manish Pandey', '+917514478179', '3603-3972-8576', 'XFFPR5136Q', '62, Connaught Place, Sector 3', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-19T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_820e76299cde', 'd587f9bdc489cd495a2d10c3e7f5b0ad0d063528875f62b904fdcee50212dd7b', '74b6b7323ec464368e57ef142d9f5f4d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5035cfa5d7c6', 'tanvi.mishra88@example.in', 'Tanvi Mishra', '+918562582007', '2247-6301-5795', 'ZLIPV2394Q', '231, Anna Salai, Sector 40', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-18T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5035cfa5d7c6', '889e636e7fe1df9010c0806dded78757e83f784a19ce4640b2b818710f11d310', '39f6edc6a86183f87cbb8b52ca6f7083', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8b64d8af4313', 'deepika.singh89@example.in', 'Deepika Singh', '+917141483838', '7237-6744-2729', 'PLUPF2037B', '232, Brigade Road, Sector 4', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-31T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8b64d8af4313', 'e01e17e153fc29df6ad1657cf8c7759fb30759e6fd2a6f2a58f3faf7e6eb7bd4', '453cd627cf8f15b56005e70eb6a5781c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5a5a547ff8b2', 'aditya.kumar90@example.in', 'Aditya Kumar', '+919570241070', '3539-7705-6480', 'SKPPO2532F', '788, Indiranagar, Sector 27', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-12T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5a5a547ff8b2', '0a9aa5e7a8135a7159a6912c74a2cb5a1ec9c20ab18ee9e6d633b43b04c3d1e1', '88c12d8afe8c97493ab1d560584c6981', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fbbb4ef821ca', 'rahul.kapoor91@example.in', 'Rahul Kapoor', '+917423394008', '3211-2444-2777', 'PEFPE8074N', '689, Park Street, Sector 40', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-20T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fbbb4ef821ca', '8d892f9ee23a9697add822dde1275229ffe349cb28b92cfa4d2ce29f37ab95e2', 'acbd34892c0ee32e34c8e8705be59f2d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_65d7d1443e09', 'ananya.sharma92@example.in', 'Ananya Sharma', '+917368848567', '5987-6774-9263', 'FKEPU2662B', '401, Brigade Road, Sector 34', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-25T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_65d7d1443e09', '3fc9db5b48acd4ff70d2ffa69f5ff4b8389583ad1f6cd46fa00445bd54cfd2f0', '49fa8307f304ae8cb03a6f977102a61e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_62d89e5c2d1d', 'priya.menon93@example.in', 'Priya Menon', '+919994660850', '9848-4637-2883', 'RZKPR7137A', '915, Indiranagar, Sector 37', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_62d89e5c2d1d', '73baeef72eea0fd91165badab9fc5eb2ae9c7065ac3bdebacc4b7ef6faddd440', '48cae98b86bd88342de2dd8d45166c66', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1fc3be8058b4', 'kavita.singh94@example.in', 'Kavita Singh', '+919193178149', '8766-3487-9842', 'FDEPM2269O', '733, FC Road, Sector 1', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1fc3be8058b4', 'a771caf3ce342d44f3ab9a3339a78126318351ef957e906eaaea369f3897f336', 'aeb1f28627dd5a44194ee63a2afeb86e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0e2e3cbe5bd7', 'bhavna.chauhan95@example.in', 'Bhavna Chauhan', '+919340817997', '3949-8789-9630', 'VJPPX5680G', '233, Sector 17, Sector 20', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-17T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0e2e3cbe5bd7', '5b0327dc77387c7a2732a30be5b9a3ec639ac5b898db44cf32c4fc41c924e353', '4970203035c51d42363c202f3e7f6601', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0eca9a6899d4', 'ritu.rao96@example.in', 'Ritu Rao', '+918807823013', '2465-9055-8006', 'AHPPA4021B', '885, M.G. Road, Sector 43', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0eca9a6899d4', '4dc3c26e9ac3665a34d2d0ae03a84ccc4c14a5ef502138ffbc5d40998f40cb98', '6ecdc62b765d2cd6d4245036ff03dbb9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ae58415b5625', 'simran.pandey97@example.in', 'Simran Pandey', '+919845857075', '6795-6345-2321', 'JLPPQ7875B', '756, SG Highway, Sector 4', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-01T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ae58415b5625', 'def40b8574a8b0fa2209452f166eb5dfb6117442d9ca247ccae1a14541b0a5c7', '287789bc64f2de4d11042f09a8fafacc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e3889d402574', 'amit.pillai98@example.in', 'Amit Pillai', '+918474868288', '4371-4400-7745', 'PNHPK5072F', '385, Connaught Place, Sector 13', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-09T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e3889d402574', '29eb22f96fdce196c4d8093b375768a54d4757701e5ee8ceef42f76105c3e0ca', '5a64db5cb113b4d05417dd3f0161a77d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fabc3d671439', 'pooja.bose99@example.in', 'Pooja Bose', '+919972303402', '8757-3374-4811', 'KTQPD0147D', '415, FC Road, Sector 12', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-06T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fabc3d671439', 'a8c152b11d31f96163285f1cf9af78b928fcbae9bb3e8c7a2fbe94fbd8d296a0', '20813a8355f6e1b990e0e61f45b7e8cb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6fabafcc1037', 'tanvi.menon100@example.in', 'Tanvi Menon', '+919580875119', '2889-9069-5417', 'YAGPD8675D', '775, Koramangala, Sector 8', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-18T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6fabafcc1037', '81dbeabf97ec9baaab918117ac1a2be4108b8813fd7349547f5ad951e35ccf18', '62a77f4a78c97fea1fc2495b94fcddbd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1ed17be84eaa', 'varun.mishra101@example.in', 'Varun Mishra', '+917749626644', '8377-7978-2092', 'HOWPK9395T', '862, Connaught Place, Sector 15', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-25T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1ed17be84eaa', 'b12220441301f12166da76613925cd3c05e459235db2f94ef6536e7f7d8a3273', '6485a1b853643a1684e9f1c13ed43090', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df11eec5747f', 'ritu.kumar102@example.in', 'Ritu Kumar', '+918315142395', '7271-6921-3046', 'ZCTPN6631M', '338, Banjara Hills, Sector 11', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-06T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df11eec5747f', '49a444f2be0692881d010c0dabca6348470344507608023348acbbd8b5edce25', '7c9072a131261ee40eae3d09a1251666', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9954aba32d77', 'sunita.patel103@example.in', 'Sunita Patel', '+919557381159', '4509-3989-1833', 'FVSPU0968H', '955, Brigade Road, Sector 24', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9954aba32d77', '55abbe405c80f93b766cdb3577cd692596152ef592c77686df1fd73bc6ce0f16', 'fc4054cd274da96e02d3b62aac639f5d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d505102da4fa', 'rahul.gupta104@example.in', 'Rahul Gupta', '+919891886164', '9394-1117-5218', 'ADWPW0245F', '21, Sector 17, Sector 44', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d505102da4fa', '4754bd4164f8e0b749d91c17ac40cda2681bd1f658238df2ea6ce347acba59d9', 'c7e78ba4af1b360b1636ee07065b96a7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6e28aa5c90ff', 'arjun.patel105@example.in', 'Arjun Patel', '+919606574029', '9282-2699-2874', 'VUDPY9016J', '543, Park Street, Sector 43', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-22T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6e28aa5c90ff', '149bbf28df3e965b613fc35305c48439d51f59981d3adead66cf9f14c6e6b9db', 'd43914f78ea67d2a05f2d90dd014283e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_45ddb573bb5c', 'meera.chauhan106@example.in', 'Meera Chauhan', '+918415658436', '7647-3225-5185', 'HFBPL1504L', '637, Indiranagar, Sector 44', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-09T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_45ddb573bb5c', '491442b99015221d695e1790929f00ec98ac95196fcc643763f0d3342ef91174', '9ce17c13865b0677a4b41e3410a34c72', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d5b92699e291', 'meera.saxena107@example.in', 'Meera Saxena', '+918116899178', '2273-3065-1061', 'PWRPT1824J', '792, M.G. Road, Sector 25', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-01T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d5b92699e291', 'adc8e522949cba73106e72d71b3df62228a474b7bac281a169878eb9d85c85ed', '3f9ba13613022582e8cf52fc99a093ff', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_352a96d004a3', 'simran.bose108@example.in', 'Simran Bose', '+917950763665', '2857-2916-8229', 'CFUPB8878R', '677, FC Road, Sector 30', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-22T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_352a96d004a3', 'f694f23d0326ea63c1db64fd161b43fbb1ec23a781f7daff5858d4d8e9405650', '6d537e6c2604fcb3c809af28e2b4963e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f4e4419a7074', 'aditya.kumar109@example.in', 'Aditya Kumar', '+919391934276', '8951-8383-8818', 'YJXPZ1012F', '299, Park Street, Sector 39', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-01T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f4e4419a7074', 'ab8c44b50e32a4bb7374aeddda52184d3cb9a49c1994d7687bc3cea6b53ebc98', 'f751ee07a2656c247f02b2a3e0691ac7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5d6ee97a63ad', 'arjun.mukherjee110@example.in', 'Arjun Mukherjee', '+917488671314', '2151-9234-2071', 'TOQPT6848G', '950, Sector 17, Sector 30', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5d6ee97a63ad', 'abaf58325eb0839a2b5a55eb89005aa0300b60081713092a0410e5ff80ff6f96', '11b1e68a36ff5d4d9aae1c4516fb1b37', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_45c617071a4a', 'kunal.mehta111@example.in', 'Kunal Mehta', '+918275979706', '7393-1407-4858', 'PCXPC4894L', '550, Connaught Place, Sector 2', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_45c617071a4a', '7901940ea6683a2b875b87b16260ad4dcd3623e68ac7ad2a67950efb8c92cdfa', '7ebccb9d61af8d7d0d5973f132e7904b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d2d3ff99a47a', 'isha.agarwal112@example.in', 'Isha Agarwal', '+918226631145', '3338-5503-8033', 'KSZPZ5961N', '638, SG Highway, Sector 15', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d2d3ff99a47a', '4b9dfd3a24cd20a88fa80c6036b7686faa8365d0138d9b5fdd3d5b62ad7cca5d', '2500582d65c0c50cfe510f234560f114', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0f2d8300d1c6', 'abhishek.mehta113@example.in', 'Abhishek Mehta', '+919481354003', '7702-7870-9774', 'XWNPG6013A', '222, Park Street, Sector 31', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-19T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0f2d8300d1c6', '30300b80d384c77f1e9164d81e3ca5d51dcadc46c44543fd6e33589aee5a3158', 'c0345d3a069bb2d74893508c03bbbc22', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_715c884a20dd', 'pallavi.chauhan114@example.in', 'Pallavi Chauhan', '+917653134288', '5944-4096-6989', 'DFVPE1633G', '520, Banjara Hills, Sector 41', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-12T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_715c884a20dd', '1c236df145c2d514349e408a3ac3dc25169a2d64ef770ef2b48f27ab35b29733', 'f98523a0c623ee66f127a3e39ac78f8d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8be60eaf69a5', 'varun.iyer115@example.in', 'Varun Iyer', '+917236576495', '7274-9122-1471', 'EMVPL6725D', '962, Connaught Place, Sector 45', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-05T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8be60eaf69a5', '798c9e16a40cd1ab8c070a4a34623118fc9406e7af9d6408654221653b7466f0', '9acd960763eebebc5673da2548c69efb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_66c55c3ece30', 'isha.gupta116@example.in', 'Isha Gupta', '+917375956751', '7161-5566-2632', 'ALZPQ4764L', '361, Sector 17, Sector 24', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-28T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_66c55c3ece30', '96b2d040cb6bfebab7024bc1b2c078969e42c253b59458194efe11c4c5bee070', '878a4581100e95f9364e6a4918e16cfb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fd3f27b7e7ee', 'pallavi.rao117@example.in', 'Pallavi Rao', '+917892499103', '4240-1013-7512', 'NOSPU3133G', '665, Brigade Road, Sector 35', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fd3f27b7e7ee', '614542398067f19bcc2c625b6603f9c47dc1d0d9c3f38cfc30a9db15ebcfebce', '5194a68f3d5ef68c06c00edb1ace991f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a55b5e32067c', 'aarav.patel118@example.in', 'Aarav Patel', '+918184979388', '4930-8713-8129', 'NMYPE0388T', '45, FC Road, Sector 19', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a55b5e32067c', '9b8f4914f97b7ee458c91c2e678eb521abd96923e3ff9f126e140d1cc3958ea4', '9786b2b52e824d73b4281012d5e4f7f8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_de4c84fcf3ea', 'priya.pillai119@example.in', 'Priya Pillai', '+919195399116', '7841-5512-6546', 'VKGPZ3843J', '328, Banjara Hills, Sector 20', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_de4c84fcf3ea', 'ee415d4ed96362d3424d23c5a9caa926eb1c2b11e78740a0f47ff0db7e056383', 'd32ec329342c4acca49c09b2c33fa0bd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c11de8c69706', 'anjali.menon120@example.in', 'Anjali Menon', '+919502483179', '2711-4831-4922', 'WSBPU4062U', '905, Banjara Hills, Sector 8', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-28T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c11de8c69706', '838fb02d6f5aa4f34fb4cd01935862043a3501bedc45479f1877db6f3e9b3797', '700573c3950202030237ba128ba86c0a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a4e50331e5e0', 'aarav.mukherjee121@example.in', 'Aarav Mukherjee', '+919872894755', '8518-3493-1008', 'BVYPA9689L', '517, Brigade Road, Sector 39', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a4e50331e5e0', '0c9f67afbb8dcc5ee57e082b25169208d242b0e87f3a8ca6db641a0adc88f3f2', 'ee8357e5b9c727e3ca690b2091f41369', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9297d53ca87a', 'tanvi.bhatia122@example.in', 'Tanvi Bhatia', '+917182854757', '5604-6913-8174', 'RMKPH9176H', '151, Koramangala, Sector 21', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-11T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9297d53ca87a', '88f053f486b0a32c4dbedc122275ba83f8832a1d8c8556332a9a2ca203b6a093', 'fe41c1a88899299d3413952cef2e78d8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aefd7afd23fb', 'anjali.rao123@example.in', 'Anjali Rao', '+919697312569', '3189-6402-6955', 'DHSPR1432B', '92, Koramangala, Sector 39', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aefd7afd23fb', '149a15a7d1e90b1cb7e70b08cf85aa8ca631b62a126315cf76da5ff17a7ec5cf', '2de09c84a40e99748f8acc0a71c296a1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_920b4b559d83', 'abhishek.dubey124@example.in', 'Abhishek Dubey', '+918336830389', '2783-1254-9924', 'HCRPP3015E', '114, MI Road, Sector 40', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-06T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_920b4b559d83', 'a5fd9efb6319cd9c9b22c3336ab1059f69229f7e4ec36bbb9ee634013060e975', 'b633eeafb7ec5987c933b9aeee577763', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b60fdb2576ee', 'ritu.kumar125@example.in', 'Ritu Kumar', '+919157748772', '9051-8672-6910', 'JLIPT0184N', '520, Indiranagar, Sector 34', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-17T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b60fdb2576ee', '4d3f55f021dcba691b16251ddf1ffb899df113f0116d86e21e295c54677a3b30', '9011427b9b6ceecc13f87dd428b52f20', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1d05d98ed3bc', 'divya.bose126@example.in', 'Divya Bose', '+917375852296', '4716-1969-6561', 'KVKPU4641A', '930, Connaught Place, Sector 35', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-25T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1d05d98ed3bc', '6ce40195707a233c53c0757495f0592fa47474b6e26054d137e154de411005ea', '95ba1406a9b620c22f4fe44fe32c7ff7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_23385b94a56e', 'amit.nair127@example.in', 'Amit Nair', '+917134976913', '5655-9529-6972', 'EKJPU2099F', '912, Park Street, Sector 15', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-25T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_23385b94a56e', 'd7d58129d151bdfbe589b994455c19fcd3d3db18e7c7cfb40b3c3008a332be02', '29d6b3ddeafacdae6313b2129fabf202', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9783cd6ea65c', 'aarav.rao128@example.in', 'Aarav Rao', '+919350116560', '6744-7650-6042', 'KWUPD5839A', '228, Koramangala, Sector 38', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-05T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9783cd6ea65c', '4a7fc42c2460602af1b5f7220cca2e11ae223b0f45ef8a67eaa02791c5f62dbb', '8b9c8e32ff7772c4fadbc6178c0362ea', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_327ec85096d4', 'ananya.mukherjee129@example.in', 'Ananya Mukherjee', '+917528791562', '2615-4244-4664', 'ROLPN2555Q', '764, Park Street, Sector 25', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-10T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_327ec85096d4', '815cfe18d8f1e8fb65dd36ea2db9f2b7a16f4aed1da79a39049a2f9cb0217cfb', '4d81c2d8eb9d1f2bd4e23bd14492b959', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5ee007c9bcec', 'amit.joshi130@example.in', 'Amit Joshi', '+919467668509', '2538-4388-4030', 'GOGPX6475P', '387, Indiranagar, Sector 35', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5ee007c9bcec', 'dcc6afb308d4f2f1a84461428da9f01662a51b75e07e8440cb043ff7749e52a7', 'd778bd266c990ae65a1cdd29e62ff54a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e44255a5a386', 'kavita.malhotra131@example.in', 'Kavita Malhotra', '+919412603180', '3477-1967-8881', 'MNJPD3996O', '921, Banjara Hills, Sector 26', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e44255a5a386', 'e4c90d084b70a762493f49897d51ee43491b70f763e5cc280a5f0db9dfcd7e72', '3825e098b380ad7748df1ff53c08bc26', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0ca6a0405a29', 'arjun.kulkarni132@example.in', 'Arjun Kulkarni', '+918316676805', '2460-2155-3027', 'FXBPM7477T', '164, Brigade Road, Sector 42', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0ca6a0405a29', '73f6c13296a499e35daa6adfadb3960871c3d25471d056601ce7960db46d73dd', 'b6e4984f7882a010a3cf5d62bf07fffc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e01a2d47ac06', 'alok.rao133@example.in', 'Alok Rao', '+919617775506', '4868-9584-3139', 'BKMPR0833Z', '93, Banjara Hills, Sector 3', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-17T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e01a2d47ac06', '054f3f3e445935a3be62d75d2095b8a926b54614c3dc3389aca255f33724e58b', 'bc4f293b2fd2bc77639698b2f2e2430c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7d3605b670b8', 'sunita.pillai134@example.in', 'Sunita Pillai', '+918326139355', '7709-5640-3060', 'TEZPW6830V', '427, Koramangala, Sector 42', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7d3605b670b8', '0ce71756579966ae5e76b9ad0d453ae5e6957dbbf9f91a16c6af96645a164512', '7e6c137ad27f8343b533824cfc3fbec0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b33aa37f19f1', 'sanjay.reddy135@example.in', 'Sanjay Reddy', '+919645995339', '4051-7326-1814', 'VSJPS8573K', '276, Sector 17, Sector 29', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-21T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b33aa37f19f1', '83d8a76e9a70b91968e3505c034e23b532e7a87233b3044bd1d7d01bca8cd766', 'a2f8c165b3922b437d22ccebccc73e1a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0e2a8a20ba9f', 'rajesh.sharma136@example.in', 'Rajesh Sharma', '+919849617880', '3482-6705-7536', 'LEIPF9207L', '11, Park Street, Sector 17', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-22T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0e2a8a20ba9f', 'd20cde6ca9132a69178ce27f3b37834554126db65c93173db4943bd94f3fc522', '5fa769fd0ca6ad9993f44069ce5e1d88', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b8ebba32b6e3', 'rahul.saxena137@example.in', 'Rahul Saxena', '+919982864001', '5763-1839-1019', 'DYEPN4065A', '851, Sector 17, Sector 1', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b8ebba32b6e3', 'f7bdf237b41d1a6ea9a559f4859cafd1c46fbbd2ea82e14f8a45fa4b58eba961', '9f939b7217e93ca0e112dc194b9b689c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1a05b456d680', 'pooja.saxena138@example.in', 'Pooja Saxena', '+918978837397', '2304-4160-8787', 'MXHPJ2796F', '790, Anna Salai, Sector 4', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-11T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1a05b456d680', '13fa7116c253f50626cf729d8e4412ecdfebcd6e80d7e865cef36a314c3a0729', 'd4d6e0b600e9d77e5a3d167a97613225', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_791eccb4b896', 'arjun.mishra139@example.in', 'Arjun Mishra', '+918601895573', '8675-3593-1148', 'ENOPQ3150H', '994, Park Street, Sector 23', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-20T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_791eccb4b896', 'db51c7315e1fa5a6dbec2cd6e81869a739f94d8491497aaa82986f93f04c6408', '03ffa438700c1ac34b40e6d22bff23d8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_503d007b51e2', 'rohan.deshmukh140@example.in', 'Rohan Deshmukh', '+919730567870', '9306-9382-5141', 'BRLPP1626Q', '800, SG Highway, Sector 17', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-23T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_503d007b51e2', 'da24b5002442965c56793a1bb1c0d5dbc73b12b212978df5eda8aa80e418f10a', 'd90697059c4488461e98497313818b92', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bab2dbed179c', 'anjali.deshmukh141@example.in', 'Anjali Deshmukh', '+919890736077', '6244-4180-7943', 'TKDPB0013Q', '490, Connaught Place, Sector 22', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-13T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bab2dbed179c', 'e1b257c2ceb71864dfaa0a79780c06b4ba9cb5eb4db7c2b792b4f984e018b472', '9d0e8e1b8f8c0ff9373d690d3636bb55', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ba19ad5004fd', 'sanjay.dubey142@example.in', 'Sanjay Dubey', '+918703955916', '8344-1707-8559', 'IWHPO9719I', '482, Koramangala, Sector 17', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-25T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ba19ad5004fd', '0de2fbb4c5a71f387bc23b9674a558a6d808bbdaff5fd60c4efd8d310b5f7b4e', '19af389f795156b50b2f93dc6115dff4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_26625c73a8fe', 'pallavi.reddy143@example.in', 'Pallavi Reddy', '+917954508121', '2447-8822-4007', 'JBVPJ6598H', '381, Sector 17, Sector 5', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-08T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_26625c73a8fe', '7deea2b9c79f533ac1175bbeb093b1240b5005e1dbca53a06aed3474faad5393', 'a4077058e3f1bff10ce51539ef808025', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4636b8912e71', 'anjali.saxena144@example.in', 'Anjali Saxena', '+919418207428', '3175-9485-9244', 'VSJPM8555F', '935, Sector 17, Sector 19', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-27T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4636b8912e71', '7810fdcc9287d7e2e4e14fd4892e2c3a59bbf4c5289b1faec9e6924ba0e4e4a0', '69779472f7beee192759fb647bb32544', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cdc05fecf6ec', 'meera.bose145@example.in', 'Meera Bose', '+917131147158', '6170-3499-7388', 'OOXPV6038Y', '334, Banjara Hills, Sector 9', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-03T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cdc05fecf6ec', '0b10cb90200bf1cb28581a300b48c4bc5c2f75f60f72a9daea4a6e30b7ae917b', '900aa5f7bb6c6a6802c16285d01ce760', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b9fc13b449f1', 'dev.menon146@example.in', 'Dev Menon', '+918631698515', '5096-5034-6396', 'NRSPV0921F', '134, Sector 17, Sector 9', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-25T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b9fc13b449f1', 'a71e8d0e7e724d4161526e89db14831bb410c5da91aab8220f920aebc416331b', 'ddb42461a88a5bfaf85f4fc98014dffc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_97d374595253', 'alok.joshi147@example.in', 'Alok Joshi', '+917796009097', '3261-7484-3810', 'IPDPW6316O', '124, Koramangala, Sector 14', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-16T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_97d374595253', '930a3ed57fd9791254934a7542fbcd21f0663306c6973b1fd341c326750b2ce7', '5535955b34d01f244d49db88b6dfdd9a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_91f0b16cef03', 'rahul.iyer148@example.in', 'Rahul Iyer', '+919181486744', '9275-2317-4494', 'LAGPO7031E', '728, MI Road, Sector 4', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-15T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_91f0b16cef03', '8e4031164ecb6fb7c276419486fc4c9a6810ae905186fb13de2804d27299ff8d', 'e83efcf14354aa6c7451583eae4f9e5f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9c50eac869a1', 'swati.verma149@example.in', 'Swati Verma', '+918516246457', '3156-1817-4450', 'IJNPF3132V', '849, Sector 17, Sector 26', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-15T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9c50eac869a1', 'a79eeb25d40b356f1a59a62a201bc55bb9fcebcc422ef3be46d11b29ae29f12c', '55ebebb8c2a945cf8e32ebc4d75f8cea', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b0d03a071fec', 'vikram.kapoor150@example.in', 'Vikram Kapoor', '+919300443773', '9664-5640-2982', 'SRCPE3411A', '700, Park Street, Sector 40', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-21T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b0d03a071fec', 'bb1080a6f9371ad1c3a6c0aa6cc8d856b258df81c2695122d45ec17853b3557d', 'aaf79e7b5169374873bd903c402ad715', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ea4ec1da5ffe', 'pooja.saxena151@example.in', 'Pooja Saxena', '+919777151082', '5300-8093-3089', 'OLZPK5156Z', '710, FC Road, Sector 26', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ea4ec1da5ffe', '9da99e1e4584656080027ed921231d511c736211fb67d92e01e1407b3f9e8870', '921e38e6fc38796bc0c3e402e06135f2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_86dd15d10a7b', 'rajesh.iyer152@example.in', 'Rajesh Iyer', '+919378284408', '8187-3597-5617', 'QDZPQ9995N', '376, Sector 17, Sector 8', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-30T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_86dd15d10a7b', 'b30a66d20354806b85b05e8f360ee3f6f20c723832d51bd25f16ecbcab9ded94', 'e0e32fa1f40ec4522abe23ac5fbc3dd9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8f32f2fff4f4', 'harsh.patel153@example.in', 'Harsh Patel', '+918792174040', '7911-9002-5557', 'LXDPW5547D', '273, SG Highway, Sector 30', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-24T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8f32f2fff4f4', '5895ac9c3d2389539bd4720ff7a3051367f26e55c58787872386b6f46ed84892', '515418cee4063b79654793158a7b3675', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_697596b4af26', 'nikhil.mukherjee154@example.in', 'Nikhil Mukherjee', '+918197448220', '5655-2089-6964', 'LWEPK8136T', '463, Indiranagar, Sector 1', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-09T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_697596b4af26', '6ab595614b2f462e84539418a6bb15d20327860e5a4452f06ad63d17ce12742c', '1171589a9adf007c47219df0c7a44c2b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6be5e8a07a0d', 'ananya.menon155@example.in', 'Ananya Menon', '+917666787157', '6501-6106-4006', 'BYRPH6464Q', '29, Indiranagar, Sector 27', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6be5e8a07a0d', 'fb1abbc807633dadf4a7ef1963db3b02334e26dce31330967829e8591754bc23', '5c3c3d464e4a6ad6ca23ee3a070608c8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5eaf19da2840', 'pallavi.menon156@example.in', 'Pallavi Menon', '+917547419558', '4246-7117-8036', 'YKNPO4560L', '749, Sector 17, Sector 9', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-09T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5eaf19da2840', '18a1616cd384268f7c8c651ed302e5ada3565afe7ea51152de47e6e5014b2f87', '8ec5ae3ccd148e29fcd3f49ab0c0e6b6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4f36e01adfca', 'kavita.pandey157@example.in', 'Kavita Pandey', '+919168581344', '5877-1270-9361', 'XEQPF4572A', '660, Koramangala, Sector 11', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-11T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4f36e01adfca', '46c6b06b270d34b6d6b843fc74dc186f6f2d5024370447b66723f2f2855c4387', 'ca2d2ad0fe2ab54a6b44fcb9d2ae7c31', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ecee40470002', 'deepika.kulkarni158@example.in', 'Deepika Kulkarni', '+919850144509', '2847-3607-8851', 'VSYPW0975H', '549, Connaught Place, Sector 4', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-16T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ecee40470002', '871b9ddc663c811462c53e6810d50dfab022c759243152fade105144bf794e49', 'c91cedd8b6d8787bce1fa0c437a69a36', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_18511f5e49c7', 'deepika.chatterjee159@example.in', 'Deepika Chatterjee', '+918327823220', '3264-2411-9652', 'ZZAPK4924I', '339, Park Street, Sector 14', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_18511f5e49c7', '0f0ee7154ac424987779976da405ec716aa953cf9c23253eb886c3f51ebda1a2', '6c6d4799faee9aa5cdb02c7c87602195', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f8f0d0131297', 'ananya.nair160@example.in', 'Ananya Nair', '+917721561555', '8634-9305-4154', 'BRMPR3478P', '694, SG Highway, Sector 38', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-01T10:59:26.166Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f8f0d0131297', 'fa46488ef83561d3b4394d54f86eeb1dd7cbc8e22aa68ad9649f51d6ff4b3ec6', '159c1dc62a5c84f5ce4da93fe83d733f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fc73c9dbc5cd', 'isha.sharma161@example.in', 'Isha Sharma', '+919205587839', '3452-4093-3505', 'YPHPJ7584A', '982, Anna Salai, Sector 12', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-18T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fc73c9dbc5cd', '3adf56ee6fd0508d9e8641d6ade385f934f79c2e211b88674baf320181275312', 'a69d905d3f93500ed35c4098d4bb0a5b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6bbf151cc11c', 'rohan.bhatia162@example.in', 'Rohan Bhatia', '+919955860760', '3046-5885-8930', 'GFGPR4836V', '898, SG Highway, Sector 29', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6bbf151cc11c', 'f318444ce7f4db97fdb0cbc5eb026fdfb80091e8294751f0b521b0eba63ea964', 'd2f1de27a0285566e32676541ff927bb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_550f873b17c3', 'rohan.dubey163@example.in', 'Rohan Dubey', '+917543627701', '2388-5553-4925', 'GUYPY4750T', '717, Connaught Place, Sector 8', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-08T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_550f873b17c3', '053c2dfa8f10e8bb92a6fdb26bdc4b849f08a7f0075d81a9a684d8ee00fec7a7', '37da680a12eb08b1be67a5ef7850850a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_41adfa5f8b7a', 'aarav.malhotra164@example.in', 'Aarav Malhotra', '+917624589415', '3003-7612-4177', 'TLNPV6879J', '776, Indiranagar, Sector 3', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_41adfa5f8b7a', 'cbfe89517b74a58708ae766839c5f0a011cde24153d555fabde348c9a2f883e3', '1d4330f530f05e3adaf60b191df5b87c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0d936f6e6077', 'sanjay.gupta165@example.in', 'Sanjay Gupta', '+917499759994', '4848-6127-5382', 'MBIPP5183Y', '667, Banjara Hills, Sector 16', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-23T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0d936f6e6077', 'b87c734eb84b27cb2e7ab4b88476cd376cb8484f997daa8819ead1b8d86f687d', 'e55c951e1c9d801976564c499c158f9a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f28c4aab926c', 'meera.iyer166@example.in', 'Meera Iyer', '+919418287529', '7322-7557-6469', 'MERPI2585W', '871, Koramangala, Sector 37', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f28c4aab926c', '753bfb0f8e05eece07580b6bbfcc823adf39c1798bba08c9d9fa5ff21de3e8cb', 'aeb31e8d1d0b3afb242804a0f4bedfdd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7f0b231714bc', 'anjali.rao167@example.in', 'Anjali Rao', '+917659459169', '4737-9737-7040', 'XIJPC8791M', '972, Banjara Hills, Sector 39', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-23T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7f0b231714bc', 'aec15eb195d03f728f4af28ef33797047e5804697902b83943a93d540f72c359', '5fa842bb718ea2a62de634f70cecc441', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_56574e58f649', 'kavita.joshi168@example.in', 'Kavita Joshi', '+919202553998', '7368-6665-7372', 'REVPP8471V', '125, FC Road, Sector 4', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_56574e58f649', '0c4d937a60358747711e43b8e724554df3a6edc3a6d214f343e52df353900021', 'f352b9b83b699d842610b2bd73b06526', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_704335e28670', 'dev.reddy169@example.in', 'Dev Reddy', '+917743490321', '8750-1602-6730', 'GQZPU1566G', '696, Sector 17, Sector 5', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-04T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_704335e28670', 'cd115f21a73299a752cbf158182801212b754ae806bcf5972afd5c39d0961574', 'e0cb7c0c2c199075404a5b8d71e4097d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_de0514ca0bdd', 'kavita.deshmukh170@example.in', 'Kavita Deshmukh', '+917376147505', '3036-7295-1648', 'UHXPK1933C', '202, Koramangala, Sector 19', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-12T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_de0514ca0bdd', 'fef71f184a530652982194a702a9d8e3fb9341fbb2e01d427f23defdd770e759', '5e7e2e39a399e80c27a2822091ca695e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_56ff3d5cc9df', 'simran.dubey171@example.in', 'Simran Dubey', '+917659728365', '8700-1939-5457', 'FROPW6346J', '486, FC Road, Sector 26', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-01T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_56ff3d5cc9df', '32c68ce07f091b00532bad490fed93c85259f186f5ee746f9f24a0494f1e77cf', 'f25f11aff280cae02810d2abc7e4a56b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_97415ecdf493', 'bhavna.joshi172@example.in', 'Bhavna Joshi', '+919604802610', '3933-2692-4704', 'WSOPE3921F', '116, Anna Salai, Sector 6', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-20T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_97415ecdf493', 'e5e0038127ad8f00006c5ea0977479c0b7ed3212290d0ae91459a33878db9922', 'db48878254fb847deb708189dc0a57f8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_03f6b994b280', 'ananya.deshmukh173@example.in', 'Ananya Deshmukh', '+919209070392', '3692-9323-6971', 'BZIPK2788Z', '533, Koramangala, Sector 38', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_03f6b994b280', '208731174d33a805c9bf76b2f55547c696462fdc5ab520fa1837a7a48743e5dc', '49645bfa61d2ea7a5d87ec22f24dbbbf', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aed70e748dd1', 'nikhil.bhatia174@example.in', 'Nikhil Bhatia', '+918637363142', '2467-6625-5552', 'BXTPT0269W', '913, FC Road, Sector 34', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aed70e748dd1', '2ee4b2916d6f54b7ff90a5f909032869afe6609e0fd8980381adadd719f0a314', 'cb91acb30f17403fbb60814386c3ef9e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ca8616e76d25', 'anjali.verma175@example.in', 'Anjali Verma', '+919502083508', '2977-3781-8230', 'GOHPQ4252E', '511, Connaught Place, Sector 39', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-16T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ca8616e76d25', '1485a9433031a9ce35299c1c8b1d2d5236d91c50516ce977a41b42e86a84ccc1', '16c5a46f3d17de399ef3e8d11e35723b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6e799f60969b', 'aditya.menon176@example.in', 'Aditya Menon', '+919534517803', '6765-7232-8867', 'HBSPX0807I', '150, Connaught Place, Sector 39', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-06T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6e799f60969b', 'e462f5c3a8ed64f080a952760a33862815b0d37e682a29481454e2d79fbf92ba', '491c37fced899ddf9cc57750bec93fc7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_51e74577d88f', 'nikhil.chauhan177@example.in', 'Nikhil Chauhan', '+918469473240', '6460-6331-1736', 'AUWPG9902Y', '964, Indiranagar, Sector 22', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-01T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_51e74577d88f', '2856f50fe05b7eac358d3bdc973970026b06ff1abb804eecf87708d0dc26f373', '3ece708b2d57d5326968cab7a482ee4e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2db91cd8c4ae', 'amit.mukherjee178@example.in', 'Amit Mukherjee', '+917525808125', '9156-9219-7386', 'BLOPB1109I', '519, Sector 17, Sector 3', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-25T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2db91cd8c4ae', 'e461c8fadeb3f3d7be95ddc225b185ac43d86a5095034a88076cde9c4104fb73', 'c2d041aec9eb0d8caf504185cd8d58cd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6685710baa01', 'sanjay.mukherjee179@example.in', 'Sanjay Mukherjee', '+917174725338', '4526-7012-3895', 'RPTPD7714P', '174, Banjara Hills, Sector 44', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6685710baa01', '27b8caee177a1c234b0ebdc8190561528c54587f1765e789464e1f61e7249bdd', '620c7377c4740033a269697427acd011', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_173edcdf1df2', 'meera.agarwal180@example.in', 'Meera Agarwal', '+919241175289', '7395-2971-9433', 'MCOPG6826W', '368, Sector 17, Sector 42', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_173edcdf1df2', '36b4e78c25147385b4554e3baab37323d11540627121c6cfc0c29bb874d67888', '02b01d60d2747f6ff8feae67ed2e4abd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e4749c77a768', 'rajesh.chatterjee181@example.in', 'Rajesh Chatterjee', '+918139530297', '9535-6216-5612', 'QDAPF9349A', '608, Sector 17, Sector 23', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-17T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e4749c77a768', 'e57d69865845e890ad9ead2d946f5b904037daea078470f8930796a22c33bc50', 'fed474149e4bec162a1dccd225df64f3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fe05b4355285', 'priya.nair182@example.in', 'Priya Nair', '+919526564107', '7761-4872-4867', 'LJMPQ0601O', '460, Sector 17, Sector 36', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-31T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fe05b4355285', '40bd171793705387720d7badd52b5363d861257eae272ea3ffd236bfa101e9d8', '00415c0740ed8e30b01c2d1742dc2d4f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5857e8519b7e', 'varun.kumar183@example.in', 'Varun Kumar', '+917438277873', '8586-9514-9958', 'MMOPX4997M', '175, Connaught Place, Sector 8', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5857e8519b7e', '69b91b6ed449344c2f9bfe48bc57817da3ddbbea3e5c479d72b0a2413be00002', '050e208ad32c237feb15b3493a900fe8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e234b5cb335d', 'bhavna.gupta184@example.in', 'Bhavna Gupta', '+917125339926', '8770-9322-7516', 'EWEPD8995V', '973, Park Street, Sector 28', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-29T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e234b5cb335d', '8231c1dfb7fe92ae8e82ec39fac3562a17e17e48e8a26bb707ecacd57c60065c', '1a2d44aac422319a562e82072bdd1e37', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4674940d2a70', 'arjun.bose185@example.in', 'Arjun Bose', '+918895676265', '9820-5940-3224', 'RVHPC7584J', '604, Anna Salai, Sector 14', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-04T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4674940d2a70', 'db8bf3177d801b436506a3054c3bc2344766092455e32256149b60ae96145e90', '9dbeb768fbdc1e34ae7efe9f7f32d746', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5ae45076e779', 'simran.menon186@example.in', 'Simran Menon', '+919393038656', '5996-4263-5012', 'USSPA1945G', '333, Koramangala, Sector 39', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5ae45076e779', 'a5b9b9d0ceb10a7c142a1f05a5558a13d1fc124c8110ce21e6a2fcba015660b8', '814ffc3c94294fce26858edb800bc778', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cbb6f0baaa66', 'nikhil.mehta187@example.in', 'Nikhil Mehta', '+918851516356', '5304-5185-8184', 'ADKPZ3204A', '890, Park Street, Sector 34', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-23T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cbb6f0baaa66', '30d3544b034e372d4f70b153bc63ae3874289cecb6c435c018404531746e3bde', 'c810b6fc0fa07179bf3a7d882f47db1e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_52b6085788e0', 'arjun.verma188@example.in', 'Arjun Verma', '+917905283557', '5671-1467-9350', 'XNAPK8817X', '443, Brigade Road, Sector 24', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-03T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_52b6085788e0', 'f6ebd99471bb870243dbcba17f42b921d5f006eeb284993cc59e9d0bdab963d2', '4e28de1d643b4d66a5950d8001cb0be4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_db6bd4957e51', 'rajesh.pillai189@example.in', 'Rajesh Pillai', '+919699891248', '3939-1980-9375', 'UKNPO0885P', '130, Banjara Hills, Sector 18', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_db6bd4957e51', '16b245c52b23d137ca3fa2da7d099f1a00f09101aff67e56a71fb4f964d111ea', '4855529b3cfbee58bce8714835b24059', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8260f50524c0', 'varun.kulkarni190@example.in', 'Varun Kulkarni', '+918423602264', '6693-6633-5751', 'FWBPU7239X', '352, Brigade Road, Sector 7', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8260f50524c0', '5335a8a52f1356c7fdb8ca3533be378c6611016c15c9371f17747b1d601aae6a', '573832391ec1186c096ab7096e011227', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f3bd919044d7', 'isha.menon191@example.in', 'Isha Menon', '+919449967162', '4562-1171-9127', 'AQYPB2180I', '683, Brigade Road, Sector 26', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-22T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f3bd919044d7', '36d6126cb5a526d302a0e76c86a685a0464363b7c8b081fed302c88223f549ad', '8784b89936564d0f7298d7da5b4fba98', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7f903f13b9cc', 'rahul.menon192@example.in', 'Rahul Menon', '+917434924101', '2222-1513-3143', 'NHXPC5562E', '554, M.G. Road, Sector 20', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7f903f13b9cc', '30a0381e529033173d4deebdff1bc40cddd6e62a4465191ed9f2b20cf0351c50', 'f7da13e8b4f246de2f178ba39a529855', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_73c9cc482aa0', 'rohan.chauhan193@example.in', 'Rohan Chauhan', '+919539562598', '7738-7942-6796', 'FQKPB7385B', '428, Banjara Hills, Sector 20', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_73c9cc482aa0', '84d91821e76b61bac6de3526b9ac5d2372b15b3584fd30fef4c601aca7103ecb', 'eda25587dd79033c4b085ebbb4f28145', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_da4791e4be8b', 'aditya.rao194@example.in', 'Aditya Rao', '+919284116296', '8483-5056-8113', 'ZPSPB4806N', '585, Anna Salai, Sector 2', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_da4791e4be8b', '45037cb647451aeae70a4639753b51b898314af915bb7a02433598e3dd6efded', 'da1013b433a018eefd618341b3e325c8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5090f4b2e614', 'aditya.bhattacharya195@example.in', 'Aditya Bhattacharya', '+919783621644', '7877-2404-3923', 'GKUPJ4620V', '254, Anna Salai, Sector 26', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-10T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5090f4b2e614', 'aeb4bc22b57bdb2c4664b55f4cfa8b6eeab94aaf5458cbe5f25afeafa9cf8aa9', '0e19435b39f63efc7c960f308ae935fc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4ac6d200068e', 'pallavi.chauhan196@example.in', 'Pallavi Chauhan', '+919567292689', '4068-5040-7191', 'BEAPA4917Y', '714, MI Road, Sector 43', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-11T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4ac6d200068e', 'b59cda5cdc4d60d7f8f7fe6aaae74938dedc451acffb4729cc2b5700bdb315fe', '6c8cff306b1467d58c693c58fcbe9a39', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ec61d4a49eda', 'aarav.dubey197@example.in', 'Aarav Dubey', '+919154488559', '3159-4035-4953', 'YNGPX7425F', '933, Anna Salai, Sector 24', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ec61d4a49eda', 'd4e135fa5d3ce35680500811c39b34ff46f0e666a8908973e794719fe1400dfe', 'be89c62af4a63d94532552a3a054d538', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b6d43f413202', 'ritika.pillai198@example.in', 'Ritika Pillai', '+918306500062', '9338-3895-4005', 'QONPI4562T', '692, Koramangala, Sector 4', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-27T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b6d43f413202', 'c17b8330110c6934d5503619941f62d84d2f8520c1e45d88aaef239360d30937', 'ad82e5ef6a14ba0abef9f6e332c04d2c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5939dde66a69', 'nikhil.bhattacharya199@example.in', 'Nikhil Bhattacharya', '+918331778566', '9152-2449-6312', 'ZUHPD4525H', '888, M.G. Road, Sector 9', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-31T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5939dde66a69', '671c39398ad44a3c89ccc520a8ddfab11e9d85ea66eac9769c58a3f78f8bfbde', 'b6b8afc35153b6803e4db449384b8d30', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9e49de185f6d', 'meera.chauhan200@example.in', 'Meera Chauhan', '+918151590097', '6753-7248-9600', 'WHAPX9350M', '547, Anna Salai, Sector 38', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-29T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9e49de185f6d', 'c2e652473cc2cde771abe0a51685e7bd1fde378f5dacaa3057f4f565199bb06d', '31f4ff790ab433d6117014da18e13c7c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b21094223f03', 'ritu.joshi201@example.in', 'Ritu Joshi', '+917397444687', '8698-7942-6527', 'QTLPN7016B', '425, MI Road, Sector 6', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-01T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b21094223f03', '5075e5778c63b6aae5f7028b12ab709ae702fd666e9df363de1ab3f53933cdb5', 'ef4b5a15d1d1277ce14ec49748d00630', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d8e7d25bd04f', 'alok.joshi202@example.in', 'Alok Joshi', '+919967323112', '4946-9362-1480', 'GUTPZ5732X', '175, Brigade Road, Sector 30', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-09T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d8e7d25bd04f', 'acf457ba65e4b5950e9b39c141d65e7551247483435335335b95ae808a83da80', '4bd8de1dce0e1e51aa22d432daac3570', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9ccd845b0048', 'priya.dubey203@example.in', 'Priya Dubey', '+917909831449', '8169-2938-9935', 'RAEPK3248R', '660, Anna Salai, Sector 23', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-08T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9ccd845b0048', '552d56b9b8e1a57396bab3d1abf11cf91774b73416b0c0cdc3038c7d00c6f3c5', 'ca39a1a395397ff4712e74644c53ba5a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6ae7b9e4e623', 'priya.nair204@example.in', 'Priya Nair', '+919198098884', '9556-6932-5553', 'MBUPE2636W', '754, Banjara Hills, Sector 4', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-23T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6ae7b9e4e623', '6435d954ef37f675f03d12ec22deffefc781309fcb9af5f4880b05fc9f2578e6', '4868948026152226aa62aedd6600358b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e1f9d38ab7e8', 'pooja.chopra205@example.in', 'Pooja Chopra', '+918186866344', '5574-3534-4651', 'XQZPE1256U', '54, Brigade Road, Sector 44', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-01T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e1f9d38ab7e8', '2dcb90660953e44e356eeacc11027cf3d85528b6da31260ec897fe5f6f00a4b2', '89de4276381213d2cb18ea411ddd7d71', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6c943908f392', 'abhishek.bhattacharya206@example.in', 'Abhishek Bhattacharya', '+919422902163', '2994-6252-9067', 'JIXPU6397O', '580, Park Street, Sector 5', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-25T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6c943908f392', '71cebba68f6102baad4073d5aa979a2dafa282a3ea3dad825fcf9dcf6e658a88', 'eb4ba014d3cc0b47e5ae718811a392fc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_473ab9077f92', 'rahul.pandey207@example.in', 'Rahul Pandey', '+918336399375', '3139-3430-6338', 'IDMPX2610C', '445, Koramangala, Sector 45', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_473ab9077f92', '2684fc2c67005cb51c45722fa5fb99c5114621d1fea7156678e0abd6f9d52cbf', 'aa5c6a0614a4c2946131cfca2172baa2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b39e9acbb5ee', 'rajesh.mishra208@example.in', 'Rajesh Mishra', '+917589808734', '5784-9043-6146', 'KGLPO7357N', '39, Sector 17, Sector 3', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-30T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b39e9acbb5ee', '15b00228b35a55b0adc9088b5680d857084878c4d918cd3a4b169b6fc510578a', '69698a353166815a9517b2085e7ce3b2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7b9893345b3a', 'tanvi.kulkarni209@example.in', 'Tanvi Kulkarni', '+919458443346', '5119-8265-8238', 'XIUPS1054N', '956, Banjara Hills, Sector 13', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7b9893345b3a', 'ecfc7cd683ce802e2c24f0d6772004635200cddbd86316f37f08089ef147d1e5', '7ae02f5c88d1177eed0c0677b4c80069', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e39e85546aa8', 'priya.chopra210@example.in', 'Priya Chopra', '+918188689807', '4007-7779-2762', 'BJNPI8066P', '278, Park Street, Sector 18', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e39e85546aa8', '0a3cc988e542b78a85685a2e36d895be0e0b5e28b7afb5a2c62982388d3a3afd', '647bd493d91b9e63fdcf8405587f6832', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9f207af03dbf', 'kunal.mishra211@example.in', 'Kunal Mishra', '+918608163148', '9474-1340-7775', 'DBCPX5374O', '487, M.G. Road, Sector 45', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-26T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9f207af03dbf', 'ad2a1989a381fc024d0db253325557b4c4ad123c9a79ffe8fa31340e22d67b11', '37d66c11706eb5f4cf1dafe2c8de8644', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_740dd7060667', 'rohan.bhatia212@example.in', 'Rohan Bhatia', '+918844506532', '2409-6616-7285', 'AQHPO9446O', '137, Anna Salai, Sector 4', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-06T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_740dd7060667', '2edaf2f021aceed92dcdd107826f38cf1b8114d016524b68952b90cf45da00a9', '9dd82a22dade2ab3aa0bbf708eb27a39', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_093e91dc31e6', 'bhavna.sharma213@example.in', 'Bhavna Sharma', '+917892057383', '4800-6058-8799', 'OEFPB9127O', '914, SG Highway, Sector 44', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-20T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_093e91dc31e6', '3906ecf5a44408abae5873bb9bd3a1594e00579f699efd0fd4ad59ef61f7e8af', '4637375670ff8cc6a654d72b4f793525', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_28f1f434fe84', 'deepika.malhotra214@example.in', 'Deepika Malhotra', '+919678545449', '9981-7492-3103', 'ESOPT6297L', '636, Anna Salai, Sector 1', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-03T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_28f1f434fe84', 'f32c2cd954bb3bff16bf20970cf0fed497179d4f75c98bfd59efec4012ab36d8', '114d3440c11e28cf92dcd099f391cf0e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e8b634e8bd57', 'neha.reddy215@example.in', 'Neha Reddy', '+918590337297', '7226-5899-8918', 'IEVPB1044P', '789, Sector 17, Sector 33', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-18T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e8b634e8bd57', 'a0dec1db3f886b36c9872f260da9132471958225aff8d5491503f042a2d72684', '6b779d2b76251d6602fc7f276356be72', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5c625cd6f18e', 'bhavna.pandey216@example.in', 'Bhavna Pandey', '+919945726955', '2465-1115-7335', 'JDXPD0363C', '772, Sector 17, Sector 22', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-11T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5c625cd6f18e', 'bb6f3300ee44a517c425e903b934c092e2266d910362281a7bad97d21f58b26d', '93a61b02af2125e673a1039add4b07a9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_33a14b9f931f', 'shweta.bhatia217@example.in', 'Shweta Bhatia', '+917979464099', '7403-7946-1076', 'NLVPD5781S', '909, FC Road, Sector 29', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-09T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_33a14b9f931f', 'e8969d5bb13e78fb3442c51898128a7d2c763d267eb973b9423ead61e1724018', 'de80e2803a9bca4a942e2dc94186c75f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7a2e2c6b1079', 'anjali.trivedi218@example.in', 'Anjali Trivedi', '+918629074742', '9217-6131-9612', 'ZBRPO4810V', '294, FC Road, Sector 7', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-24T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7a2e2c6b1079', '20e65ab7ff69b68ffba69f5cc939aa050ba98af076e8957744fc74965ba32976', '807d907a7cf02b797b8847556fe22b51', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0c6a04831f5d', 'tanvi.pillai219@example.in', 'Tanvi Pillai', '+918274986156', '9378-8785-2863', 'EATPL0061V', '366, Indiranagar, Sector 22', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0c6a04831f5d', '15f2451f59392a4d218cc60bd0bca5632362e335e84b14317d6576078fbf3f21', 'a00d36f67470aaea7bec9266fe69ab7b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e13d9b277504', 'nikhil.kumar220@example.in', 'Nikhil Kumar', '+919456683774', '9581-3903-4763', 'IPRPB3456V', '105, M.G. Road, Sector 12', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-19T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e13d9b277504', '4a2d7558ff0947173da639766173653e802b3668733c62bcd372ebbb99d897a6', 'e34863a9656760c7dd1f87ea5412a668', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f9647b901d92', 'aarav.singh221@example.in', 'Aarav Singh', '+917399915828', '3154-7914-6781', 'ANEPK7905R', '285, Banjara Hills, Sector 5', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f9647b901d92', 'a528547c460e16623832ab8118739b0bc6bdda3d6772db52c4ec92fc786305ae', 'f69ec409c69e297ad427e59aae138901', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6cef978a57ab', 'sunita.verma222@example.in', 'Sunita Verma', '+917186855942', '2907-5323-5567', 'AYYPH8955W', '574, Brigade Road, Sector 19', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-22T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6cef978a57ab', '88d54f9e3916222089e5537ab46c9f036f3156f6ca0efd5df7b96bb9adc66832', '6ac2ddfab7f1ae45d484d9801f9e01da', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a354a7c4cdc5', 'sneha.trivedi223@example.in', 'Sneha Trivedi', '+917797462450', '7744-8471-4637', 'BDPPR8369Y', '209, Anna Salai, Sector 22', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-13T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a354a7c4cdc5', 'c7151e3ef3f1311caa0b253ebc466f19e8016955512bb065dfff21037d1a0b40', 'a569cfd2638d9bba8877410873712398', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_acd76746789a', 'deepika.rao224@example.in', 'Deepika Rao', '+917759774724', '3680-8438-4782', 'VGDPR5434I', '253, FC Road, Sector 25', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_acd76746789a', 'a57cb0b0ad4ef34441c66885257f962ff978bcd3225e2415f3c2e82d6e86d7bb', '0ca38c60a125f0d899b87535749b8e37', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8336d6e979ae', 'priya.singh225@example.in', 'Priya Singh', '+919952888847', '2748-9206-1223', 'OPZPQ6386I', '1, Connaught Place, Sector 30', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-08T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8336d6e979ae', '7ff452eca6066b82ff8764dee8d6a92ad438934b45c1b5a8e82b84ee5b18d7ba', '12d1045741e8c1fb88571598177ef7df', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_244abd467732', 'ananya.dubey226@example.in', 'Ananya Dubey', '+919671790956', '3538-3929-7703', 'GCIPG2778H', '31, FC Road, Sector 38', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_244abd467732', '42d393949653677e4cf4718aee60d103f038530963ba491f8b9dd7d070996896', 'a622c43af2421b0b5df973b6d1b9d05c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0bf377c33c25', 'meera.pillai227@example.in', 'Meera Pillai', '+918838964780', '9681-3945-9445', 'TUNPQ8355A', '173, Brigade Road, Sector 23', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0bf377c33c25', 'f26bd90a55f15f975c3bb511c7062963022fc2460eec3c559e7a120cf6a97aff', 'f7b4b672f828b1d2dd641ef0f43ffd51', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1c033bfe815e', 'abhishek.kapoor228@example.in', 'Abhishek Kapoor', '+917539700414', '6492-8578-1644', 'KRQPR1360B', '805, Banjara Hills, Sector 5', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-08T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1c033bfe815e', '8ab8a4449590112fe25d29c6580cee8bc56ab9df498e8fc5d4d18f6a25d33be8', 'bf10b171337139e44241c001e5917cab', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e16cbad3a1db', 'siddharth.dubey229@example.in', 'Siddharth Dubey', '+919282122963', '3406-7812-6581', 'ZNKPJ7779F', '593, Banjara Hills, Sector 34', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-25T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e16cbad3a1db', 'feccfc299278814210660acf7a756a0a077795060fee479a381f7f324c461eb9', 'b5c9a8e82d5643807a5fb7ac9478a99d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3e67ce25890c', 'divya.kumar230@example.in', 'Divya Kumar', '+919168471104', '5703-2392-5941', 'RLHPE2808R', '968, FC Road, Sector 13', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-16T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3e67ce25890c', '800bcbae20db7db46414b39e49276243d3b099369e2e5324a7c2b38840e2b99e', '202152d61fa6a92ce3d82c150b4816f1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a1d2e656cf6b', 'rajesh.nair231@example.in', 'Rajesh Nair', '+917439111598', '3586-7904-6217', 'PELPO0082N', '885, Koramangala, Sector 2', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a1d2e656cf6b', 'd2a425d97572d5c6dfacfa67e3c303e7d857b023adb7e878f8a867cb27d5c30a', '3762f964a581a1b1afa7df7cf5973425', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_17abb3435a36', 'karan.joshi232@example.in', 'Karan Joshi', '+919423573501', '3790-8754-3274', 'FJHPB1825O', '305, SG Highway, Sector 39', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-25T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_17abb3435a36', 'c12032e0bf9822a4673f9621abb396d2a488b0db6ee6aefbb426aa11f37a5cc1', '5d6932e10a9e14ab10b3050c9bd9ca97', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cceafd0486c9', 'ananya.joshi233@example.in', 'Ananya Joshi', '+918963953375', '6419-4575-7071', 'UMOPX6482A', '791, M.G. Road, Sector 27', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cceafd0486c9', '8aa9f5e3f521242e468cbe3ba36e3d2ba27841567eb6256a8a9ae55ccf885b6e', 'b06ee1ca039eaa4adb7fe14cd03eb170', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_92c4e2bd2cd8', 'priya.mukherjee234@example.in', 'Priya Mukherjee', '+917408266299', '2152-5091-4269', 'BEZPA0281B', '962, Banjara Hills, Sector 2', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_92c4e2bd2cd8', 'f8efdaec33f7f9892a216a0dc37ea24079b502914db55901f41c58aac8a9dbe7', '351944a2fa95cf62f4c07aa18f7e364b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dde25b2c38d8', 'deepika.kapoor235@example.in', 'Deepika Kapoor', '+917990381111', '3039-1304-3274', 'FJTPD8989B', '446, SG Highway, Sector 20', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-16T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dde25b2c38d8', '7e2b3fcd271c632965f399214a16f0c407141bdfdb45e42156c23bb9325051c4', '59cea9a8c4f17d95906c36269c7d946c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_940a7797d9f7', 'siddharth.deshmukh236@example.in', 'Siddharth Deshmukh', '+917437940103', '2439-3997-1881', 'EAGPC1813M', '921, Banjara Hills, Sector 11', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_940a7797d9f7', '438c1563511886b7047c8c58d243e2d16cbc20d9c582d2b52cef86678be05c63', 'befda3a5b52128287fc6892de2086f00', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1fcabdc7bd79', 'siddharth.nair237@example.in', 'Siddharth Nair', '+918174396206', '8596-8488-5362', 'PADPP0577W', '346, SG Highway, Sector 32', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1fcabdc7bd79', 'a6867f31870ace1b9fb3f726c71b5c8bdf3315e0bfe487c47da0cc3f36c5074e', '53891eb25271e62c06d9a89268b2aa6d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c55100337eac', 'manish.trivedi238@example.in', 'Manish Trivedi', '+917767620825', '8579-9844-7298', 'AXCPK2597M', '993, MI Road, Sector 36', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c55100337eac', '22a455e2e05662e906814435e4acf00fab88e91d46868c802449b0ff28fb4c46', '22c7be1c0b6b2d8a8fb047e77674f04a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_978fd98ff4b0', 'aditya.gupta239@example.in', 'Aditya Gupta', '+917238142151', '7960-2488-1860', 'XZWPV8660T', '619, Connaught Place, Sector 11', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-02T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_978fd98ff4b0', '468b58730fb16b4c9b5aceb00db519063f8678d3ea7125a21a9e7b1d9c889195', 'cc635f1b7adefe198f8ae1df08aa2381', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_19cce90764a7', 'pooja.patel240@example.in', 'Pooja Patel', '+919977195767', '4905-6475-1380', 'LUYPW5622F', '391, FC Road, Sector 26', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-27T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_19cce90764a7', '2bf37d2bb5ebee7de078cf2f46d7fdda4004ec659c14bd56da2b476ec7186e18', 'f81024ff10cb5e58c21626e86d2b4d1c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aaa8dea93fc7', 'ritika.mukherjee241@example.in', 'Ritika Mukherjee', '+918150739001', '3169-1230-5753', 'YXFPN6687D', '490, Indiranagar, Sector 15', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-03T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aaa8dea93fc7', '99d998311daf030bef93da275ee5982371029e2afa4ddd256a7c7c4fa22cb75c', '82554be329184181e2dec6a10b6c87f2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3694d6cc30ef', 'sanjay.kapoor242@example.in', 'Sanjay Kapoor', '+917395051221', '6619-6185-9066', 'ZFCPG9109E', '94, Anna Salai, Sector 26', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3694d6cc30ef', 'd87223d1e2f11cddec00a2164cd306f2fc521ec95a7b16373254050d9a9e778e', 'c52b202e995553a3e6be711847859132', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_08e2d6e2954b', 'simran.verma243@example.in', 'Simran Verma', '+917136700755', '9905-4663-4109', 'JDFPM7220N', '916, Indiranagar, Sector 32', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-08T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_08e2d6e2954b', '07c6577201865d1dd6358c3e431638ef68fa6473b4bbe16fdcba26eebacab1bf', 'ae4f4135c9625375e22dac0814d4b5f0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7ac29f6e7491', 'arjun.dubey244@example.in', 'Arjun Dubey', '+919555881639', '7330-3020-5991', 'CWNPW5588H', '766, Brigade Road, Sector 42', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-15T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7ac29f6e7491', '87b45708d642c5adb34957888c2c327b46e4708639191e229d8190bbeabedd04', '605e9d82b4449942cd6145332b6f0407', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6aae7f8f1ae2', 'kavita.iyer245@example.in', 'Kavita Iyer', '+917445843175', '8526-7416-5096', 'OFQPX5263I', '257, Banjara Hills, Sector 11', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-02T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6aae7f8f1ae2', 'ea230b3161b51d825fb7098d2b533ae776c7338d3e9ea8e1feb4e8ba141c1c39', 'c929cf0af573e167a43a6e77f5a02bc1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_11b93926c5e3', 'aditya.bhatia246@example.in', 'Aditya Bhatia', '+918291450816', '8249-2457-7636', 'FABPT1420Q', '908, Park Street, Sector 3', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_11b93926c5e3', '7350f4eb8bc67b51675419a31c58b55afd79d825e7447b664b268c2bf2b786b9', 'c45b8349f126dfa5565765f7e01a06d7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d8265b5895bc', 'ritu.malhotra247@example.in', 'Ritu Malhotra', '+918828197140', '2246-5178-1465', 'AKCPB2665D', '878, Anna Salai, Sector 44', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-28T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d8265b5895bc', '856e3a4b8916b3b302f1437eae709e1588d2c539cd6865993c5e4d3960b6a28b', 'a67b6f34ae867ac6591bfc70320cd1c1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_912cc20b1a3e', 'bhavna.joshi248@example.in', 'Bhavna Joshi', '+919899078385', '2926-3440-2649', 'OIFPL5065P', '234, Anna Salai, Sector 29', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_912cc20b1a3e', 'a364f4261c1a769af42a699377ea10b884dec480cb733325dbbbba9b0cc8db25', '90fc69e98d53f5ef6f97bfeb4eba8ba7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c6993422a5cf', 'gaurav.singh249@example.in', 'Gaurav Singh', '+919165497583', '3463-1414-3762', 'DHOPE4757E', '912, Connaught Place, Sector 11', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-20T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c6993422a5cf', 'efd3d9de8882350f39aa0da624156ab50d76e909cea4345b5b12d3a060b060ea', 'ce1c81d026306189e8fd1d020fffc7d9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_edb866fd4ec4', 'amit.chauhan250@example.in', 'Amit Chauhan', '+917683905963', '7346-4829-8727', 'EIUPV6806B', '907, M.G. Road, Sector 30', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-31T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_edb866fd4ec4', '01be37a7988e6f73561edb1ba5dfd109f01bc796fad2b0016cadb9ece450a863', '6330a6d94c6ef44a69463a85c3060502', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c3053a2f6d35', 'manish.kapoor251@example.in', 'Manish Kapoor', '+917800344348', '8889-7995-8209', 'MSIPL3710S', '972, FC Road, Sector 32', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-29T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c3053a2f6d35', 'ed5cfcfeb715c364763f5a024a2139693ed675af62ef0229f246ff77659e5aec', '5855255ef66dfc8aee93bb722ed2c640', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bacdf40e2a54', 'ritu.pillai252@example.in', 'Ritu Pillai', '+918303475041', '4596-2414-8352', 'AKBPD6376H', '47, Connaught Place, Sector 29', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bacdf40e2a54', '73860604b5d60a5e6777b96d0897780683a8786187e3dc410c63ce05016bb72b', 'fcbafcbb3a4165b2e8aba4896b3c43d9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ddbead38d19a', 'sneha.nair253@example.in', 'Sneha Nair', '+917313878219', '7998-5899-8448', 'MDPPR7057V', '879, SG Highway, Sector 32', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-08T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ddbead38d19a', '42f17fca182aa35d282d80ee6f00358e30c0c36296c299f776663a9ed3254ff1', '2b4351b9eac4b68e2282e0b6a737c3b6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c485d0663165', 'shweta.reddy254@example.in', 'Shweta Reddy', '+918633182392', '9553-8495-1294', 'TDVPV9072E', '913, Park Street, Sector 23', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-03T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c485d0663165', '4b95b117d8f04b859795ed3eb455931d03992c2c31c6b4d5db26a2bede0f1a17', '306b02573fce56b4186a4fda7c54401f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c049610ff3b9', 'neha.bhattacharya255@example.in', 'Neha Bhattacharya', '+917370906864', '8499-6767-3737', 'YPFPJ4762H', '35, Banjara Hills, Sector 18', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-13T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c049610ff3b9', 'b0e37313f86f9693b21ecc873781fe469544fa34157cae186d3c826dfdc043f9', '30da391902e613ab85f5aa0467b5602d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bb7ca775d2d2', 'ritika.rao256@example.in', 'Ritika Rao', '+919686364749', '6616-4159-9306', 'CXUPK7122Z', '564, SG Highway, Sector 26', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-04T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bb7ca775d2d2', '4dce42a74648b2e3c70718c3bff4add4f6aa689453c685dba80e68b034a8acec', '82188f1f1745f8803587b2cab57a9de6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2d6db2e85279', 'siddharth.pillai257@example.in', 'Siddharth Pillai', '+917306543366', '2093-3067-5778', 'GLOPE3890O', '184, SG Highway, Sector 39', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-17T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2d6db2e85279', '4d3b66e657a2386582e831e1ae150fd4f9ca95f35b411c861ee6ab9f50d29ddf', '111fd68de21b15747d8fd05be0914a60', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_75910c22573a', 'amit.bhattacharya258@example.in', 'Amit Bhattacharya', '+917417653013', '8293-7834-6445', 'CWEPS9094I', '888, SG Highway, Sector 26', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-27T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_75910c22573a', 'a79dc694b7bf005ef0f943dd68641ee029a63e3a4c9a52ae8cc2996aaa90d5c8', 'e3c51ea95bb5e4c7e6dab87e0e3f41df', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_96e649a7141e', 'divya.dubey259@example.in', 'Divya Dubey', '+919501020321', '8069-1963-4990', 'KEWPT4374R', '515, MI Road, Sector 22', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-12T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_96e649a7141e', 'bcb926dd962ab1045f169225c91e505b3c5ddcc5838c1fa72e90168f808df403', 'ead6bfe632e74536ddeafebac7cfbceb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1115682e6518', 'sneha.deshmukh260@example.in', 'Sneha Deshmukh', '+919198104316', '4782-5443-2439', 'QOQPY6173U', '210, Koramangala, Sector 19', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1115682e6518', '5208220afad0ca7432d03352335d7d460945d2caee3cadd46a6cc263eacf0976', 'ad71d328f683f360059093508c445022', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8ae6c00964d0', 'ritika.mehta261@example.in', 'Ritika Mehta', '+917975090510', '8345-3641-3566', 'ZVMPF5662A', '756, Banjara Hills, Sector 33', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-01T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8ae6c00964d0', 'bde823f0eff9e82fd966125631f588d6194ed4bf4054ac0eb2c2d701fed0e700', '0fedb4cb224dd882627b3e23c1e96d64', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b63f19dc0076', 'isha.menon262@example.in', 'Isha Menon', '+917435342302', '9091-2470-1901', 'ZERPL2263G', '776, Koramangala, Sector 41', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-21T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b63f19dc0076', '354b7d4a38d4aecce407ff7cd7dfd47f8c3b9608265446eacce4fe1625cc9d9c', 'f862158105749136e12802173b43ac75', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_80368c6f2715', 'nikhil.malhotra263@example.in', 'Nikhil Malhotra', '+917235798527', '8334-1891-3402', 'HBEPG7398K', '940, Park Street, Sector 25', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_80368c6f2715', '1ab6928c53b37b66f35a0d79cf2ff8f47bfd125fbb74b3ca815f1e080c009e49', 'c7a0bc5f648fde47c2c030128e4717ac', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_79628cd66798', 'sunita.pandey264@example.in', 'Sunita Pandey', '+918956543206', '9142-6671-2179', 'EGQPW0243G', '690, Sector 17, Sector 27', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_79628cd66798', '6325b35e759af2af861a664232e62bf7c34dc8cbb6eda7f7f7579744abefe0de', '5d68cd39abd0b65c8bf4410c46b007d2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_130fcdada25a', 'manish.deshmukh265@example.in', 'Manish Deshmukh', '+917800744784', '6003-7740-7184', 'BTUPP6371B', '352, Koramangala, Sector 36', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-14T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_130fcdada25a', 'a125f23618479b1485c60ca6851a45b22cc47d44d2672cbb08c6b1c16546b29d', 'f7dcccba18804dda8605384fc577d0e1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a793595896b1', 'ritika.reddy266@example.in', 'Ritika Reddy', '+917178366763', '2805-8183-4542', 'ABUPI8951L', '422, M.G. Road, Sector 13', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-31T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a793595896b1', '7c1b797ee622c6e50f40f6d90871012491ef633330ed1a0b7ee9fe0e2673ee1e', '15822bbcad4411d708b02e405d6ce1de', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5cb6a06745a3', 'isha.deshmukh267@example.in', 'Isha Deshmukh', '+918580307420', '3287-4477-9330', 'AYCPT6396Y', '18, Anna Salai, Sector 41', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-17T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5cb6a06745a3', '115177ff882e2322d9e30022013b3553ff5eaa7cb3fe688aa7fcebcf2d46acf6', 'b980cf35b09f394995d4d61b1e919fc0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7433067c0892', 'varun.rao268@example.in', 'Varun Rao', '+917886954964', '9114-3341-8620', 'CKQPL3759A', '765, Koramangala, Sector 16', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7433067c0892', 'c62f4a6103e2f62b19eb00887da8a6a592cf6f2a3290cefbd9ec802dc7ff82d8', 'e63981f18d6adb27bcc5f6417940b5ef', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f72bad5dd14e', 'ananya.chatterjee269@example.in', 'Ananya Chatterjee', '+919141751496', '3642-7770-9498', 'QDOPH6283N', '390, Brigade Road, Sector 36', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-20T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f72bad5dd14e', 'e8b0f8cbd72d35017386f3d59af6cc6132dd4e5c942bbd2f825ef2e8bd916647', 'a0169c3c113a668b04e570a131cab2b0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8992051a2907', 'abhishek.bhattacharya270@example.in', 'Abhishek Bhattacharya', '+917772482076', '9700-7694-7209', 'LPPPX9005E', '734, Indiranagar, Sector 13', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8992051a2907', 'a98f58422e0f93fa386284f62aded9dd0ef9a5ef366ab38e9db740e40aeb12e5', '380828e5576c3ae04c99802eb940730a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0fb50e5c428d', 'sunita.gupta271@example.in', 'Sunita Gupta', '+917248408344', '9809-4875-9294', 'QWDPP2904U', '101, Banjara Hills, Sector 24', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-15T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0fb50e5c428d', '971293b162ae1be1ed4f0ba6474843bf21fdc5bfa4579817a5a905f8a29a216c', 'b7f3535257a6cb92c64a870ef1f108d8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_eadb2ea8a2a1', 'varun.menon272@example.in', 'Varun Menon', '+917977644223', '3943-7887-7580', 'XMUPK5684X', '923, MI Road, Sector 11', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_eadb2ea8a2a1', 'dbcb8cf7cf81963e43ca105e462c7a8245be2418c025c8bc23d7e9ab78876f79', '437aa8964187e95e1011ff4dcb84517d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9bb3ae744ed5', 'varun.pillai273@example.in', 'Varun Pillai', '+918731686981', '7449-7824-4551', 'AHCPH8446N', '49, Park Street, Sector 44', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9bb3ae744ed5', '075e24b1abc6cf0bc628cbdf1afc0ff7987f8d506e1124edcbb44d4cd0dbd61e', '5554217207705226206b4add2c876824', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c004bae56525', 'alok.kapoor274@example.in', 'Alok Kapoor', '+919233571584', '4093-6186-7615', 'TGYPP7344G', '806, Connaught Place, Sector 38', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c004bae56525', '44fd1c5ce1b6a3fadf1371f35bfebfc2bfef7f2ec6a303f2d7cc89cfe88a9245', 'b4c9d80faa16131a988d3d424d1d54d0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_87e9b0a425ef', 'anjali.mukherjee275@example.in', 'Anjali Mukherjee', '+919167431872', '4313-2298-2973', 'QXBPZ5654P', '76, Sector 17, Sector 15', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-29T10:59:26.167Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_87e9b0a425ef', '19ffc401c48056bf833e3c875821120f9f95ef92618d37f0a3ad4e3c7f9ff43e', '29d9c4b86aab3d98fff5ae86ff52f7bb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c0b537f483dc', 'rohan.mishra276@example.in', 'Rohan Mishra', '+917723489600', '9678-2664-5432', 'JSPPT7321P', '555, FC Road, Sector 21', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-19T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c0b537f483dc', 'e8aeeeee58dc68efb782b286d3d1454dfb1926f3d630fced1cc7e5df9e2779b5', 'ca70e8fd490740ce99a7a8bf6764d6fb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_295833293af5', 'gaurav.trivedi277@example.in', 'Gaurav Trivedi', '+919994888779', '4598-2323-7983', 'WYFPS8420O', '805, FC Road, Sector 14', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-29T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_295833293af5', '3b193d0a500f74c0a3fe35255ce91b198de9165c063cc898bdfbd1fc1e10a010', 'bc8e06dd5e140f902ff40ea90005c4d2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_72564ee2aafb', 'simran.chauhan278@example.in', 'Simran Chauhan', '+918697432139', '7830-4330-6225', 'QLSPA3244O', '67, M.G. Road, Sector 33', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_72564ee2aafb', '03e57d632bfd214d0c3fab7f2a70b3a83aceaaa5b9d6f6c4e63b8a3af2621044', '4cb2d54383993e1b7601fe5f80a1415c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_48a9c881d617', 'priya.bhattacharya279@example.in', 'Priya Bhattacharya', '+919966872030', '3635-4184-7053', 'XNSPE1195D', '821, Indiranagar, Sector 14', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-17T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_48a9c881d617', '7d8ed48ec0757838f5d4e0a6f4f89e8719f8170668f0396af2caefc842b8492a', 'db0ca4a50d615c73bb383ac9ce6fbe0f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d176f87f441b', 'simran.chauhan280@example.in', 'Simran Chauhan', '+917231637758', '9831-6646-1915', 'IDEPO7191Z', '308, Sector 17, Sector 9', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-28T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d176f87f441b', '9d471647c70f5f9af0d5b0862269f5121a3046c6a22d5415c8a976cc20cb8880', 'ba401eae28b50f46fbdde659752bc757', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_73d449ca28b5', 'rahul.chopra281@example.in', 'Rahul Chopra', '+918111859638', '5967-2043-6598', 'POXPJ7573T', '305, Anna Salai, Sector 4', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-10T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_73d449ca28b5', 'd32d7139625631dcb056209baf29c346527e98513c0b054fc2bae494c3acede9', '3528010c00add33c2bec18fe301f386b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_90f2876a586b', 'kavita.iyer282@example.in', 'Kavita Iyer', '+919908774115', '6777-8861-2417', 'ENMPL4822K', '411, Anna Salai, Sector 21', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-12T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_90f2876a586b', '0ec466d3b0b3bb8b2549c87fea09dfd105509f574e2590c934bc8a429b6e8b76', '6072aed5b87ed47ae572279403aeb94f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d896c1c25c96', 'pooja.patel283@example.in', 'Pooja Patel', '+919172103551', '6299-9014-1539', 'BUGPL9299E', '411, Sector 17, Sector 6', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-01T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d896c1c25c96', '19939e6d525e7cb75a1a08b9b2cb971933ba49fbb414504275c6bf7ac82ae4aa', '3b2ca3ca4630dc1935477b74c0bd2be0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b42e43151649', 'swati.deshmukh284@example.in', 'Swati Deshmukh', '+917650025251', '7806-4420-1000', 'GVFPT8169U', '904, Indiranagar, Sector 12', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-12T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b42e43151649', '5f5a8210ac3511fa4972f1b5a148c2483f35492d056a44aa505a57c0af4dc4fb', 'e1ebecbcdd56cf947e8a09e12cdfd2bf', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8753981bc5c2', 'bhavna.reddy285@example.in', 'Bhavna Reddy', '+917820956753', '8951-3166-9165', 'HPZPE7188F', '509, M.G. Road, Sector 43', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8753981bc5c2', 'c7b8bdf584ed3434fad5f4e3d68eaa8e06c689de71bfa1300a811c8989ca353b', '9ca826281da6390e4110450f6ab8f7ad', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9dedc2d799c5', 'deepika.sharma286@example.in', 'Deepika Sharma', '+919225568682', '5591-4389-6254', 'JCXPG8386G', '282, MI Road, Sector 14', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9dedc2d799c5', '5e5f4cd83597241bd8f1abcfc8fd4dfd2a1d8974625b884c27c27d9829630fda', 'dd5cbd81ed6c994bf73fabaf4f926608', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d077742b1a91', 'alok.chopra287@example.in', 'Alok Chopra', '+919191865505', '7484-4998-1236', 'FLJPR9000M', '646, Brigade Road, Sector 3', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-29T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d077742b1a91', 'aa0c6cc4fd59175740a37492ccff1024b6cc87c28272c4e2802cde0a6afa9fff', '9ce6d766d4be7f175de4dfb38205978e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f1b35679f74f', 'ritu.mishra288@example.in', 'Ritu Mishra', '+918521061731', '5793-1438-8219', 'KNEPW5854S', '444, Brigade Road, Sector 35', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-28T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f1b35679f74f', '6f82d3e74335f05a3ccdae247b287cea1669765455571fa25400311fc249bd59', 'f62cd2562f83f529106b9c5c6983611a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_adaff0a52a25', 'ritu.nair289@example.in', 'Ritu Nair', '+919492296311', '5761-8926-1087', 'PDTPO9441L', '184, Brigade Road, Sector 16', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-27T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_adaff0a52a25', 'a0ff8d8eeab17a776d0df55b120684004b37217a43660a355e41ed31e8e2dea0', '0436db7b99492eecf1cb046816d4aa42', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_217bd6263ab7', 'vikram.joshi290@example.in', 'Vikram Joshi', '+918552363290', '4568-5119-7956', 'XPXPD8901F', '980, Koramangala, Sector 20', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-16T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_217bd6263ab7', 'f8d25584c4c023715b52c59753106a9544dae0eeb7c422744aafef9353e3fb8b', 'f6db96fa3df8bcebde5f7565992bfb61', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cbfd584120d9', 'kavita.verma291@example.in', 'Kavita Verma', '+917478142600', '6784-7359-5770', 'PZDPN6710C', '252, SG Highway, Sector 8', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-27T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cbfd584120d9', '0ec89e1e512cad21d67ac528aabe9b647b10f772acdb8e4f965d6c1b0ffd8363', '791a9e6770b6579410b898a08d3d9342', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f8467b096b0c', 'nikhil.verma292@example.in', 'Nikhil Verma', '+917569583937', '9993-2574-3623', 'NXLPO6959Q', '284, FC Road, Sector 12', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-17T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f8467b096b0c', 'f7e27b10ad35d9e1c31f7e54ed0119d023ba22caad935dd551711be97bf8e8c3', '97d315861f672e0b044474484b0692cc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_819344245154', 'amit.gupta293@example.in', 'Amit Gupta', '+917727093771', '9311-1140-6596', 'ZQHPC9963I', '375, Park Street, Sector 19', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-26T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_819344245154', 'd3b2b2d196e0b4aadd87a062d89ad335ca51d0b7398c442a3c2e7e0fd0517edb', '8a420e207f9e308e65c79630d2493d08', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e7f78160b59b', 'deepika.bhatia294@example.in', 'Deepika Bhatia', '+918898696483', '8877-5911-5207', 'SNIPV3482C', '583, FC Road, Sector 29', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-26T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e7f78160b59b', '8228bd021a7460b1111d91238ce832d69d8331130c56f2ba453004055a97d1f9', '56f1ed14ea187d8500bc740133ca79cf', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_daf035454a5c', 'sunita.saxena295@example.in', 'Sunita Saxena', '+917462594526', '9769-1942-6942', 'QZAPR4294B', '164, Sector 17, Sector 3', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_daf035454a5c', 'a9462501733266e3879d7a5bcca1e5cc20da8adc058ac1c71c776031a6682ce2', '1606213650c2d103f76db3e93222ead6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_00fbe4112504', 'rahul.verma296@example.in', 'Rahul Verma', '+919536326706', '4652-4212-7892', 'EWGPP9044V', '923, Park Street, Sector 3', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_00fbe4112504', '32608db8ca8c6c94ec5ae132df0a7185599ad635f3cdefc5819489349c6ac799', '49a1c13bfbe5b9d56f8a8b90109075ba', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1900bce08054', 'meera.singh297@example.in', 'Meera Singh', '+917687285385', '4613-6188-4753', 'ZJIPE4441F', '462, MI Road, Sector 38', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1900bce08054', '315bd3efbfe98a94bbaf8332745f85d52bf1aec9ffe60a2b10d873ffe58818db', '7e9154bb3d1eed7b1c1e4db76a8c22f0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ec9cca986f5c', 'alok.patel298@example.in', 'Alok Patel', '+918769112318', '3483-3244-3526', 'HCKPT9542W', '757, Sector 17, Sector 39', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-09T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ec9cca986f5c', 'a8356482eadf5c3f479d786a1fb22342b5c7f5d47f8ece72131ae4b2a98a7b72', '098d8a6bb631292bc12cf83fe80039d2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f677dd0bd84b', 'manish.sharma299@example.in', 'Manish Sharma', '+917591511318', '2195-3332-7965', 'VGYPV6642K', '42, MI Road, Sector 27', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f677dd0bd84b', 'eebb6f39fab938bf2795587775644254b24cf89a5aae348ace4558ec0b8df9d2', 'c42378864db88956deece4aad1feac76', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1ba5b245f601', 'alok.deshmukh300@example.in', 'Alok Deshmukh', '+918814529543', '5953-8484-9491', 'XRBPZ3161Q', '530, Banjara Hills, Sector 27', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1ba5b245f601', '9da2ca31da79ec7706a603ab8aba663280ad6d8f1abdc1f352d0d45a71cbbd26', '7b4d9daa534b3eb95555bf3fb87c4a56', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_179db21aca57', 'ritika.kapoor301@example.in', 'Ritika Kapoor', '+919636371620', '2791-9323-9497', 'YVRPD3860N', '822, Connaught Place, Sector 18', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-20T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_179db21aca57', 'b022c16af7c393b4b20ce1cbc9763d0b0799a13d95ba328428b9eefccb46c42b', '93b33ca6c0440cbe1ffa2d80c1cc112d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bb835433a19b', 'rahul.verma302@example.in', 'Rahul Verma', '+918601578195', '7493-2183-4575', 'MYSPU5430B', '288, Sector 17, Sector 24', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-06T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bb835433a19b', '3e896e50864f5ed2db1ad0579bacc2773060abbda56c9e66ed2adaa2604c3b7d', '167c59d87da10b289e3917fceec62666', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df157ba597c4', 'nikhil.saxena303@example.in', 'Nikhil Saxena', '+919654878221', '7390-5589-5424', 'WFNPL6952R', '951, M.G. Road, Sector 28', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df157ba597c4', 'b672a663705e4e809d5e0122a512c6c2805066f52925a3d48a6cd532a3fc4fd0', 'd12f4e6e062824af6fba2b057e5d80ca', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c39c5704dc6b', 'gaurav.chopra304@example.in', 'Gaurav Chopra', '+919938959795', '7075-4809-8159', 'SYYPE4599V', '401, Park Street, Sector 37', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-15T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c39c5704dc6b', '8862baccbe783c8e9a3a4369deb15ff926bf145f9dcf7ffac3c82108caf2a065', 'b52387dcc7abb22d0890d7b0b3dde77a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a9bc8ff72285', 'sunita.chauhan305@example.in', 'Sunita Chauhan', '+919564060966', '3679-4188-2492', 'ACSPZ7985Q', '328, Koramangala, Sector 40', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-29T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a9bc8ff72285', 'e6070e2ef3261e47d55192e77e7def73132c79e9be3d0d3a1ed3ef5c2310bbad', '8610d6bf920aec3df6d112ad5e2351cc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa68fa3af960', 'priya.gupta306@example.in', 'Priya Gupta', '+919412750453', '2705-5354-7836', 'LAIPR8035K', '582, Connaught Place, Sector 16', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-18T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa68fa3af960', '854bbe11f7af7af46c9db323c200244aaf3b5b23c0e889baa82f8c0c57c554a8', 'caa25b03e981ac89a3e6dc64f43a107c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_047ad314ed22', 'pallavi.mukherjee307@example.in', 'Pallavi Mukherjee', '+918443186732', '5788-4144-6002', 'TDHPI7066J', '424, Brigade Road, Sector 17', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-13T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_047ad314ed22', 'e30b1c3c9fc7fafcd74b504b052fd436636be0147c19e5681dcc0874f623b2d4', 'ace2726ae492c4b17e8ffdd9ac9e98e0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_de39a19adea3', 'sunita.chauhan308@example.in', 'Sunita Chauhan', '+917792560576', '2137-8278-6377', 'VTIPI1165R', '899, Brigade Road, Sector 3', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-15T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_de39a19adea3', '7fda6ae72d966aef45e0f226dbb6dfa3447d6bfde6e20050dc5fb2abd8b54c56', '510cf293f77ec3122154e7313e37b37c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_326c1a85e59b', 'arjun.gupta309@example.in', 'Arjun Gupta', '+918672332343', '9037-3902-4282', 'MZCPC5010R', '31, FC Road, Sector 45', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_326c1a85e59b', '927bb6ceb7819f22fb0200fdb879beeb977313e0e62b6eddbd1bd5c1a841d939', 'f102a09e47eafe31d88cb742e3104f76', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c68b0083f8aa', 'arjun.mehta310@example.in', 'Arjun Mehta', '+918232993680', '4912-5799-8221', 'AUBPO7316N', '677, Koramangala, Sector 31', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-16T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c68b0083f8aa', '91f83ee75ce719bd425219bd592890354a2ba82641e105a4b9f31f532767e9f9', '488405fdfa863f53afe1d742a0154964', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_84119944311b', 'rahul.agarwal311@example.in', 'Rahul Agarwal', '+919306765705', '9328-6209-4784', 'WTWPB5106B', '658, Banjara Hills, Sector 32', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-27T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_84119944311b', '1686d322a384dd8afd1ab7445da1d31cdbbfd5e7175a02d0492bd4bd47047259', 'b5151eae11f526f25d30d72df23163b5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3716aad0f985', 'rajesh.pandey312@example.in', 'Rajesh Pandey', '+919892485315', '6627-6344-3765', 'BSQPP6142H', '47, Brigade Road, Sector 6', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-09T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3716aad0f985', '6529ed361b4ac8c3fe7939cc482d6a7c20d76999be10f62c80686d7ceb4a6939', 'bd4302f8044b579092fc05fedaa70d35', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa929f6f67fb', 'anjali.nair313@example.in', 'Anjali Nair', '+919717720716', '3129-6483-5645', 'EREPX2334A', '681, Koramangala, Sector 6', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa929f6f67fb', '1466e99a7cbd22593bdc456ac4dd328616bfc8bc5549a875128878dcd94a6da3', '34698c781855283a011710c456629461', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0f1060fe3074', 'manish.pillai314@example.in', 'Manish Pillai', '+919747312608', '9506-3052-2417', 'ULEPL9364E', '746, MI Road, Sector 11', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-17T10:59:26.168Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0f1060fe3074', 'eff759a11b4138e31d005470de7b56b209441f32ed31010d8bae58234166e0d5', '699de3ac90f5ee36ac30d20bd55ff730', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c48177e34a97', 'rajesh.chatterjee315@example.in', 'Rajesh Chatterjee', '+917630371871', '6913-7107-3835', 'BOYPQ1661B', '125, Koramangala, Sector 2', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-12T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c48177e34a97', 'fb549beeb1b79abf9daaafc1264a571a523e11257f61c74b3b3f6729a30dd16c', '3f0657b004dde197c57355459a15b5e8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a7eb5aeacc74', 'ritika.reddy316@example.in', 'Ritika Reddy', '+917499729219', '5097-6456-8056', 'XJPPL1161L', '170, Sector 17, Sector 19', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-17T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a7eb5aeacc74', '803a98751319440b3ba2375e1ff00cac0d9718e50d48b8d555ae11558be628e9', '9c06ac3f2930479a15ae251f7b5f08d9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_00439a27157b', 'nikhil.nair317@example.in', 'Nikhil Nair', '+919427688426', '8513-7483-7940', 'UBCPL2235B', '307, Sector 17, Sector 5', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-13T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_00439a27157b', '15c9416b943e34338283ac25adbd5a5ef77c465644c0280585fe5675a73fc2d4', '9be62b90e5d89c9bfbd60272184fc118', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_56038d6e1919', 'ananya.gupta318@example.in', 'Ananya Gupta', '+917841284877', '9306-7488-7495', 'HFGPB1332U', '896, M.G. Road, Sector 13', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-22T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_56038d6e1919', '06202e6ea91e80560ce5531c3fa944935db4b2a5c6e751132508880bd44ed3f8', 'f0908ec3e5701b87ecdd180f31c43c22', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_91550c4e72e1', 'pooja.patel319@example.in', 'Pooja Patel', '+917944659685', '2804-8958-1645', 'HZLPA7293Y', '23, Anna Salai, Sector 14', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_91550c4e72e1', '21ea8d37339efec830c869abcedfb1ef8bbcccc28dceffd71b2be52596549976', '6c055657fb851aacac570fe4c134daee', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d277b04fbefa', 'neha.chauhan320@example.in', 'Neha Chauhan', '+919602827915', '9530-9725-1029', 'HLPPC8583P', '461, Koramangala, Sector 23', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-21T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d277b04fbefa', 'afbfb9159395bce343702523e868cdae0819fdab44bab1acb0e4145cecbf9cce', 'fca483ba9c40f7b475b3357264f47954', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a112929e0926', 'pallavi.nair321@example.in', 'Pallavi Nair', '+917706136382', '2566-9395-8158', 'VHVPY2541W', '113, Sector 17, Sector 14', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a112929e0926', '233bede7750d7e03baca9921897701096baeb275eff6fe8b63e08ed866a09702', 'f1f9529b842fc7e8ff7d3bdd48ef349a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_90efd7dae0db', 'aditya.kulkarni322@example.in', 'Aditya Kulkarni', '+919966662994', '2821-2333-7366', 'QIFPK3889P', '161, Indiranagar, Sector 19', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-28T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_90efd7dae0db', '38eaa2098bcec7ddbbc1c62a481f975190a3f7a6457253b1a1da68480b6a0aaf', '8e50b6511d4dfc29893829aecc8666b7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_32c749e7dd76', 'ritu.malhotra323@example.in', 'Ritu Malhotra', '+918185791126', '2296-4118-6302', 'PCVPR6992N', '874, Banjara Hills, Sector 13', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-04T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_32c749e7dd76', 'b12e11b8facde3a6a352d1c348bc392a9b2749bf5c6a5eb270b6c935265699e6', '1f23dd8c356d6e9a41622cce585d1f6b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2caef9ee7dc0', 'neha.mehta324@example.in', 'Neha Mehta', '+918214670442', '4718-1196-3598', 'COZPH2853F', '444, Indiranagar, Sector 26', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2caef9ee7dc0', '6303b4e39912a5688e9c733a2e7da166ac2985c060e829cf6d212d14380b38db', 'fc1a42f85a862032d80159e58b029013', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_37a3fce778f4', 'sneha.trivedi325@example.in', 'Sneha Trivedi', '+918601798396', '3395-1294-1623', 'HPDPE6947J', '572, Park Street, Sector 35', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-25T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_37a3fce778f4', '63f50f764dca5ab03f18fa50404d2a50d032225075fdef3f0e218d6747f931da', 'c1865ad66a3510d62a938ccf4acd2b79', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d165369dcc2c', 'shweta.nair326@example.in', 'Shweta Nair', '+917428819084', '3198-2043-2922', 'HAWPO5986P', '44, M.G. Road, Sector 18', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d165369dcc2c', '587b1efe7887a091e578b206d6e6e15b2083ffa21b29a2c16f2045e6ca9b757d', '5d64f12ad1effb9ab1954f8eccc3d9b8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bc39450caddb', 'sanjay.verma327@example.in', 'Sanjay Verma', '+917150024069', '9876-2566-3920', 'QDUPN2213M', '388, Koramangala, Sector 26', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-28T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bc39450caddb', '0c14176ba9834ceffd0a30f62590d9e430c9aa70f3c1a3eea6489689c97cb138', '8dd9855e95934abdbe944e1f2e934552', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_570bc2c987db', 'shweta.chauhan328@example.in', 'Shweta Chauhan', '+917265660089', '4297-2818-6040', 'PBUPM9901Z', '628, SG Highway, Sector 28', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_570bc2c987db', 'dbc122a52cd50f0218206e5cbffb0acbe66c536f26040718dde25ed7f0fd1627', '945e622aeaeb1919ae9f4b782ce3940c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cbc3be89be27', 'rahul.sharma329@example.in', 'Rahul Sharma', '+919705228906', '4915-8881-4444', 'LHLPE1378H', '362, Anna Salai, Sector 34', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-05T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cbc3be89be27', '998503be1f520748b3a0b8ea731d6ce1f0a8a824ff7ba1d30cf532e7b41feec8', 'f151d11b960184a86f9cf21a6fba6919', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d540b16a1b22', 'ritu.mishra330@example.in', 'Ritu Mishra', '+917786319250', '8999-1778-5884', 'GZGPM5495O', '932, Connaught Place, Sector 35', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d540b16a1b22', '3e0a3bc74d21d9ab5a44bc3f7701bc80fce176a011d0b321e95323331f59054f', 'e6ac8fa409a21567a8d1945c0e3dd7a1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_34a4b771b05b', 'amit.reddy331@example.in', 'Amit Reddy', '+918537092137', '6270-2253-1811', 'BYDPD4639Q', '445, Anna Salai, Sector 13', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_34a4b771b05b', 'fd7fef5397d1f02e850ac8c2c58d2c8793460169bf3eb9a5fa5d26592482ed19', 'd0bfaa048cabb17a38cfd79978334d5f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fd43d84674c6', 'ritu.iyer332@example.in', 'Ritu Iyer', '+918284424628', '2780-8906-5338', 'ZOPPB0546I', '557, Connaught Place, Sector 13', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-12T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fd43d84674c6', 'ef9cb085f807850f8d955845f0ff275d7b38da1aab34f0515a659ee5f5906d68', '7527d1fe1beb526d5cef33b608c8efe8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_82444bd64e7f', 'simran.pandey333@example.in', 'Simran Pandey', '+919214952423', '8821-5376-2803', 'OORPZ8783A', '399, Connaught Place, Sector 42', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_82444bd64e7f', '6c4e1fe532f21ca7650343145abfcb5ae856a5c74a98c6b21358fff03a6a8ee2', 'e7434fac460a67488133311b5f14e22a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c46250fad18f', 'aarav.mishra334@example.in', 'Aarav Mishra', '+917690218730', '8126-2937-8928', 'POJPN8037O', '543, Indiranagar, Sector 31', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c46250fad18f', '7308b328ca667f901edf316f0cd52182eb284f1e78c74bcc1996261ce94e05bb', '3abf7f10cdba34a72879331613d9f272', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0e0d6abc1fd6', 'kunal.patel335@example.in', 'Kunal Patel', '+918739003052', '9012-9204-8775', 'UUCPS2176K', '467, FC Road, Sector 4', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-24T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0e0d6abc1fd6', '363dc1ddafbb44d9217482fe181275d501203f58bca5bf4feeff4243ad800c21', '4db72fb0a87f013e5ec26c48ba79526b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a66f25cfe5c2', 'rahul.menon336@example.in', 'Rahul Menon', '+919516018134', '6287-3450-4124', 'OWQPL8074Z', '888, Banjara Hills, Sector 29', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a66f25cfe5c2', 'a1bf4c330eff3f1f80a5f71c5c60c1326293b628725b467ae12324707bd6e3f3', '9026f9bff7e6bbc9335b3dcc70ff135f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_15c68b202fd1', 'gaurav.kumar337@example.in', 'Gaurav Kumar', '+918996202713', '2829-4660-1686', 'YWKPN0410G', '592, Connaught Place, Sector 34', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-15T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_15c68b202fd1', 'd97e61d5eebb5f3ce84b642f066fdcc5e98dfabaa5126cbbed6d3509ce83c6a6', '239fd10abd0cfe81cf749070c8a7de57', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cefbe8cd11a6', 'amit.reddy338@example.in', 'Amit Reddy', '+919398002404', '7707-7320-3774', 'NBBPW9050Q', '656, M.G. Road, Sector 24', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cefbe8cd11a6', '1dbf83181001fce825814311f4a01b39e0719a04a4c925288c75dc5c06aa2045', '418db0ffb9f24e3f99c8cfffde001f11', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e7e7637e4a7f', 'harsh.patel339@example.in', 'Harsh Patel', '+919185878618', '6777-2409-7828', 'QDZPO6954C', '982, Park Street, Sector 31', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e7e7637e4a7f', '1943db42901e456b2ed013596db1ca7dbfe9bb81a3b156f2b7c5f176558cb444', 'e5d2d93e201b337c8c881704163e10e8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e6b19a8d153b', 'abhishek.reddy340@example.in', 'Abhishek Reddy', '+917765546031', '5020-9225-8678', 'OIGPW0291Y', '353, Indiranagar, Sector 10', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-12T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e6b19a8d153b', '0e05b91efca113433a7fe7734d62ac809072a8f0109f1f96448d09a5f7dbd38e', '71ebaebb8bda08548130118c49a48ccb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c552677b570c', 'gaurav.kumar341@example.in', 'Gaurav Kumar', '+917664211950', '9163-9103-3981', 'LLZPU2888T', '716, M.G. Road, Sector 33', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-29T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c552677b570c', '7dcb636884475aa79a3c86181bae44d0b479988e06837bc69f45cb58b244327d', 'bb3d239941affb082d7188f865c8aa6d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_caae1a31e1d4', 'shweta.mehta342@example.in', 'Shweta Mehta', '+917435639777', '2818-9924-9522', 'IWKPY1815S', '643, M.G. Road, Sector 2', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_caae1a31e1d4', '869200c161e0b5a5dd7ebb3e61f383d884a38a244a013453aa54bd188b28c24a', '253160b519b39bb5b6bc6052ee398b3a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9e21c88b2d06', 'harsh.bhatia343@example.in', 'Harsh Bhatia', '+919582682431', '6795-8852-6209', 'QHSPB3472H', '16, SG Highway, Sector 28', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-21T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9e21c88b2d06', '2d4116f06d45b2f7e0d10b4131c8d8586f38d0ef81bcb3e89d3cda0c642f6086', 'd20aa54566010d7dbb28a533a6d5e3f5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ba2130167ee4', 'pallavi.kulkarni344@example.in', 'Pallavi Kulkarni', '+919819599115', '2187-8982-6843', 'YHFPQ0512M', '342, Brigade Road, Sector 42', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ba2130167ee4', 'c532c94b9718c492a41e03c891062b6a895e455abd8e257e68dc1aa3fd911103', '1d1a8c4c083cb41f15f42438dad542ba', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ef771511aca3', 'swati.kumar345@example.in', 'Swati Kumar', '+918558462385', '5501-5062-8972', 'JOPPX8577R', '756, Connaught Place, Sector 11', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ef771511aca3', '32f265fea1dc6e41602908a7ad690b14a1058a601e13b21bda96ac2b1b22b49e', 'd72c0826ef4183f003f48b93cde855c5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a4270b644783', 'rahul.malhotra346@example.in', 'Rahul Malhotra', '+918638940246', '6090-2222-8152', 'QOZPO3455Q', '724, Brigade Road, Sector 4', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-08T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a4270b644783', 'b1d692d22c1e61eee662df0803d8dc3720193fd41126e75dc2f77825665f56df', '9a43e88590f2c45f1e7b44da24500289', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_828a2d0240a4', 'deepika.deshmukh347@example.in', 'Deepika Deshmukh', '+917237606240', '3449-5759-8827', 'ITYPE4317X', '308, Brigade Road, Sector 5', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_828a2d0240a4', '755b701a3d23dae4f208e777da61213fe73f3692ad176bbff19f1735320f1a28', '5c73b387bed1620fe02f3f178ac59871', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7bb4de5bf8a8', 'meera.menon348@example.in', 'Meera Menon', '+919455682959', '2322-8791-4906', 'BGLPT1779U', '633, Connaught Place, Sector 23', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7bb4de5bf8a8', '373f4504b517c1d09cd83759ea30d2a4b11e5a8f17e463ba9ccdb4fa1c63850e', '5d202bb16de7808f2f839e65663a6d5c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7f6d126dc208', 'vikram.mukherjee349@example.in', 'Vikram Mukherjee', '+918823105733', '2965-3953-9763', 'TTBPN7423O', '934, MI Road, Sector 18', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7f6d126dc208', '12d6ae0133cb59eaaa124391270d0a5fbe9445421e5c97d448691056c36f4b10', 'd4c05e36be2885fb61f645e6c54ce0ea', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cfed680ca25d', 'simran.bose350@example.in', 'Simran Bose', '+917276949936', '4690-6572-7513', 'BLRPK4492A', '363, Brigade Road, Sector 9', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-08T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cfed680ca25d', 'ae6f1b3a71417e3daf9c15f1470d910555df7d9a0bedc2c43a60806ffcc8e456', '78bac9802d2f7eccb07af8469f260116', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7481099949d5', 'arjun.deshmukh351@example.in', 'Arjun Deshmukh', '+917934510103', '2934-6883-5214', 'HVZPD5790S', '940, Brigade Road, Sector 44', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-30T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7481099949d5', '0659dea6ca84f47bccbbfda556823d44321bf70625a209745cce212b4ccfd3c0', 'e0926797cb9e4a43973065b89e010313', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_596c59642f18', 'arjun.mishra352@example.in', 'Arjun Mishra', '+918574387589', '5482-1313-9763', 'UOOPJ0041L', '526, Brigade Road, Sector 26', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_596c59642f18', '1d79975008d8ca23f86e9177215a2abea276793780663649bbc9a0b6eae18981', 'a56ae956a045cc43e3ae091ece9660ba', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_65a3d8550696', 'abhishek.chauhan353@example.in', 'Abhishek Chauhan', '+918316642313', '4658-9261-8646', 'NFRPJ6946O', '524, FC Road, Sector 25', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-15T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_65a3d8550696', '6c7267491c60a6ff9a747ec49a366b04f35f2cd75241d7a80281de8524fbcff7', 'd693248548d3f0f29d324d4fdaef3ae7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_10ff28208528', 'vikram.reddy354@example.in', 'Vikram Reddy', '+917671652421', '9526-9493-1842', 'YTVPK5324C', '324, Park Street, Sector 29', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-19T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_10ff28208528', 'a5257490deb0897526da17993cac646b979d5d6239d12540daae64b7df4ed8f4', '5045f3959a37b36b81ba9c14f22d357e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d7ec69e14402', 'anjali.bhatia355@example.in', 'Anjali Bhatia', '+919612771651', '9309-6672-1579', 'ZPCPX3543U', '963, Indiranagar, Sector 30', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d7ec69e14402', 'f501ce8ae6f1daecbb69b8dfd44b1cce7512eca298649d8cead2b07d4d3bf886', 'fd27fb7a6cdadab8ed7fbc2bca0f0b6e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a7efd75a41fa', 'anjali.reddy356@example.in', 'Anjali Reddy', '+917369594849', '2565-3770-8493', 'AHPPN0847P', '619, SG Highway, Sector 23', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a7efd75a41fa', '1fd753105c23062e315064c1d55bed307f1658c190c293ff1becda3d373b921d', 'c871e0a081ba801b242eea8cc24763b3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f10c53d195f7', 'amit.rao357@example.in', 'Amit Rao', '+917526964537', '8350-8177-8091', 'JOLPF5835J', '456, Koramangala, Sector 22', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-11T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f10c53d195f7', 'b7edaa3335576888a0ff2756df6a3dc7ceda268cef40dea1ad821eb6e916faaa', 'd4c2f0e3acd3c6850203bae18362b8da', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c2c3c6f5f0bb', 'tanvi.deshmukh358@example.in', 'Tanvi Deshmukh', '+918688050993', '7367-6935-9219', 'KYJPP9440E', '605, MI Road, Sector 39', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-20T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c2c3c6f5f0bb', '1a0244bc19cbe4009466f1ac7aacd94efdbeec8240b289632f65ffbc8fc32469', '207d5d666b8fcaf8ae7ee0908cd802b0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_519e3e270b6b', 'sanjay.deshmukh359@example.in', 'Sanjay Deshmukh', '+918743398387', '4928-1395-3607', 'VZGPR2113B', '767, Park Street, Sector 22', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-11T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_519e3e270b6b', '4093fc047ca7a9e57e5f0cb9f5671a654540170ae26d8845c664f29390de9c56', 'c0876833812f5855794e4cbbb3e49898', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9e4b438aa8d7', 'divya.deshmukh360@example.in', 'Divya Deshmukh', '+917107350252', '6744-4772-5714', 'GZCPE9513L', '956, MI Road, Sector 8', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-12T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9e4b438aa8d7', 'ea65233fed1b9ddd9d9851d97db0650580f928e3cb42a2ea82fbae53ba6ab0ce', 'b8550574f4c7226c796f1fa4a2ca2c06', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_65e3a9504b19', 'isha.malhotra361@example.in', 'Isha Malhotra', '+918468531855', '8441-9845-6221', 'ABGPK5718T', '680, Connaught Place, Sector 24', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_65e3a9504b19', '2681f9e62c576d597ae20e8c1d82bebe398854b54c2f1f51e674a11eae8877dd', '6b80f473374642870f47b4557530c085', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0e22b21a9c36', 'sanjay.agarwal362@example.in', 'Sanjay Agarwal', '+918863921896', '6968-6780-3362', 'IYXPX3882N', '54, SG Highway, Sector 41', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0e22b21a9c36', 'f7921c8246dec5d15e11eacbd1ad87694c9e1c0296da29614f0dc29e743a95f3', 'ff6bb06d13deef55dfae901d156aec78', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa80cc844827', 'anjali.singh363@example.in', 'Anjali Singh', '+918994604150', '3839-7361-4732', 'ZCDPM1843M', '581, MI Road, Sector 19', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-27T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa80cc844827', 'eece435c1da9f22cca3ee97a98137982385fbef1ee810579e39efb8bab890f7b', '85319a8357341146864b271bb27c4f8b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c61b754869ea', 'dev.chopra364@example.in', 'Dev Chopra', '+917802483153', '2743-2810-5309', 'MYGPI2131O', '268, Anna Salai, Sector 29', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c61b754869ea', '9ff976116ac27e65f97825a2d89bacc348d0ac72b3072f4190c293fdfe8f380d', '711b8d2b77d8312aed81a069e16b84d0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ab032be15372', 'pallavi.saxena365@example.in', 'Pallavi Saxena', '+918485746475', '3010-3322-3169', 'KRNPR8311V', '390, Sector 17, Sector 13', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-28T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ab032be15372', 'eaacdde42e6bfcce202813f21de4447dd31930b4ce7cf7234dced4337a971f7a', 'f7918d8db2e0e475ceede6e00d5c416b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_13522817a25b', 'deepika.patel366@example.in', 'Deepika Patel', '+917977541322', '8604-3565-9885', 'DMFPL5488F', '603, Koramangala, Sector 21', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_13522817a25b', '537f709db51782e9e0801ce7770ae2efbf6ced95566e3c67ea0e0c81c091be6b', 'b3a2302ef091de58c65c6fd95a4bc8a3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_871d6acf297a', 'karan.singh367@example.in', 'Karan Singh', '+919500571921', '4982-7731-4661', 'WXPPY5171U', '127, Park Street, Sector 11', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_871d6acf297a', '74f502b8703f18e898fee6a2d4bdcfcb6b00016191c259a7b66217b44f794a4e', 'cd0211c499128b2a679142fad41c07d6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cfdc8b0850ec', 'sanjay.rao368@example.in', 'Sanjay Rao', '+918212259603', '5668-7427-2577', 'GACPJ8152A', '544, Connaught Place, Sector 36', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-29T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cfdc8b0850ec', '48e08d7b9731d6b94a8b5616dd0783ac96f2bed8724abb899478cb80471baa6f', '5f0fcdece3a723da45ddbdc8f56e8b92', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_90e08d48ec84', 'vikram.mishra369@example.in', 'Vikram Mishra', '+917665342213', '4015-7723-9108', 'JVUPB0156O', '667, MI Road, Sector 25', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-26T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_90e08d48ec84', '78d15b6df4525f8ee81942e0648fd48adf79912e16e0b44a5d5ddec40e7121ed', '96a40ecb18ae3dd335bc46fe4a85146a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aac2562f618b', 'manish.saxena370@example.in', 'Manish Saxena', '+918682849856', '6515-7637-1464', 'DNGPY4100S', '190, Koramangala, Sector 44', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-20T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aac2562f618b', '8cb18f82629b55ab5acdc7ef9e4ccb79d156e12c291a8194fd3d7d9650996284', 'dc13a89dbe94015cb09d2ce19bf631ea', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0b2300f24a7d', 'kunal.kapoor371@example.in', 'Kunal Kapoor', '+919879354371', '2705-9074-1690', 'WZPPT5120C', '599, SG Highway, Sector 18', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0b2300f24a7d', '34f3d08f4c075a850524c048c8f4c36d3e1a129a4290c5fa7b4cbd7e741d4deb', 'cdc2c8b751d21c1f288cd4559eef74b0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fc6489e1a8b9', 'priya.saxena372@example.in', 'Priya Saxena', '+918640813089', '7635-3928-8334', 'PJMPV7395U', '343, SG Highway, Sector 15', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fc6489e1a8b9', 'dafc291ce93c5230da935384b28bf441107e61061796e76fbc5552c2ef279bf3', 'e094f3eaf709acc6fdff6b574abc39a9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_467d1ccd8b62', 'sunita.sharma373@example.in', 'Sunita Sharma', '+917139117124', '8423-7014-8860', 'SZOPI4724U', '796, Indiranagar, Sector 17', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_467d1ccd8b62', 'c2ee7d3b85566798f64e99c0898881c6deb222979f4f8c8dac680e4b57befbbe', '0acac2ac07ddc55877b63c6792be1252', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f37ab8657a67', 'priya.mukherjee374@example.in', 'Priya Mukherjee', '+917390263644', '9381-5293-3433', 'HNEPN9119D', '879, FC Road, Sector 36', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f37ab8657a67', '9c8448586cbf1fd4e6d78d9b15fd37fd641bc1f0c28179ed51c3d1fb3760c517', '4e6e5ab1d0e7064dc25e9409eed0ac81', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b4e1c27f0e2a', 'neha.bhattacharya375@example.in', 'Neha Bhattacharya', '+918593777187', '7241-1649-3219', 'FCQPL1252Q', '149, Indiranagar, Sector 39', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b4e1c27f0e2a', '0ac6a97f078ace2a44fdf005d812cf06ab26da3660eeef1cfb31270c3bb0d7e4', 'f1856aa4f3657d0fc2f8a682da1530f7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2a97df3c4035', 'sneha.gupta376@example.in', 'Sneha Gupta', '+917433563412', '7098-1531-4901', 'TPYPM8110R', '925, Brigade Road, Sector 26', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2a97df3c4035', '1672f6bea194d1f3e8942864038094fd103b9f96e495f0f00c988430cda4796e', '963ad845224f4edf8b5bf54059c84f9b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_40bf4bcb7915', 'anjali.bhattacharya377@example.in', 'Anjali Bhattacharya', '+918598520941', '6444-2534-5614', 'TNMPG8340Y', '125, Koramangala, Sector 37', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-15T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_40bf4bcb7915', '56785ddcd5eaf227356df16ebc7b6641074c2ea4e25ddebcfd4fdd4060d4f84c', '6be458a9e07f7d8c58b09ad1aa362b3d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c4379e1758b0', 'deepika.reddy378@example.in', 'Deepika Reddy', '+919911541954', '9886-3252-1722', 'VLKPX7049Y', '645, FC Road, Sector 34', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-05T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c4379e1758b0', '01d6fd841f3acd90f5cd22a541316864d5f479da8f5ee15e2e2b4b28f990106e', '8f209caca4e3f48548c937ffddddec40', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_db17e4c17373', 'rajesh.rao379@example.in', 'Rajesh Rao', '+918301141475', '7313-9810-3117', 'ANAPY1515K', '139, Sector 17, Sector 21', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_db17e4c17373', '3cfdc91520684abdc317e039f24b81fafedc70051984889a6e4947858bbd85bb', 'a409ced2f60c10b43a41e27f7a654c76', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c8e3ebbb1dc5', 'amit.chopra380@example.in', 'Amit Chopra', '+918173911400', '5507-6649-5454', 'MMHPR7486P', '844, Sector 17, Sector 23', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-11T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c8e3ebbb1dc5', '4c4da180cf10733beca1ae6f452a40fee22918c4ebc1c719d1a1bde11a591678', 'fbed31e01dae42b41aec5f572e141d80', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df6990ce187e', 'arjun.trivedi381@example.in', 'Arjun Trivedi', '+919956832286', '9127-2173-9447', 'XVEPM9513S', '834, FC Road, Sector 28', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-25T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df6990ce187e', 'f16764b28b8fda8587939b5f89d182a21b7141498d6290391da6b506f8dc3b21', 'bb69b7433171f53dc3b2804d668a41ff', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_da16c7008d19', 'aditya.mehta382@example.in', 'Aditya Mehta', '+918386054121', '7903-7238-7187', 'ZAFPJ3477O', '555, Banjara Hills, Sector 3', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-08T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_da16c7008d19', 'f0daa38e0220fe021d20afde4c67e759eb5437531cd07d8085bee1be4f41c960', 'd80fc775689a7f0b8a20cf788ce3bff3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c5cc2e903946', 'anjali.bhatia383@example.in', 'Anjali Bhatia', '+918983556340', '5481-9288-9382', 'RYRPN4962G', '123, SG Highway, Sector 28', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c5cc2e903946', '7482d5005e233a65bb40560df40be086e9da3becc58b4dc903ceb6bc1d1b34bd', '469f846c0a594db9931a5f7c6b556a8a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c5972f6d19b8', 'tanvi.kapoor384@example.in', 'Tanvi Kapoor', '+917324048535', '5719-6837-5023', 'YDOPT5098M', '307, Sector 17, Sector 18', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c5972f6d19b8', '8770a0d31033450c85b0fbaeff742830e0b7c7780d61733bcaebfa4b234d7980', '9d2269d318618c38cb10f37cc6697550', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_35d944d58873', 'arjun.trivedi385@example.in', 'Arjun Trivedi', '+918632947219', '9067-2316-4761', 'ZPBPL4631B', '74, Sector 17, Sector 1', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-28T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_35d944d58873', '6e1f8f7236c442a0e1a2126269cccae2dbb4a03d2cbce243853351f791359c5b', 'ec1a242283af210ffe72ec33b9d5a89f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_16bf5e97cd31', 'abhishek.pillai386@example.in', 'Abhishek Pillai', '+917258926311', '7569-6031-6256', 'UOBPB6492I', '785, Anna Salai, Sector 37', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-25T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_16bf5e97cd31', '5765ca49fd23b4f3297ec739a3ad23d0587352a0d02a0f6646b95079f99ad5d9', '1f688e924bf7007398db1b4f274def01', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d8a70eb1c273', 'vikram.bose387@example.in', 'Vikram Bose', '+917689888061', '2761-8795-5990', 'MDZPM0449W', '706, Koramangala, Sector 38', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-17T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d8a70eb1c273', '52bfe8f8cef757ec904d43496ec00fed4c9b97ae2c672fe0eb312b90de0ba74e', 'bfb5d9b6be4beba1d740250fcd5d6c1a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dd23c3d3feda', 'rajesh.chatterjee388@example.in', 'Rajesh Chatterjee', '+918662607141', '5588-6204-8794', 'QXBPB0810W', '802, Brigade Road, Sector 29', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-15T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dd23c3d3feda', '05791cd31cf2402fddf155a10a9b4e0f051eaa97a12eaf75c98d5f6d8726f118', 'c55069d01340193deb2e101c6ed79b89', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_da8d00d130ca', 'dev.pandey389@example.in', 'Dev Pandey', '+918171704312', '2237-6424-7295', 'VURPF5233H', '529, Banjara Hills, Sector 25', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_da8d00d130ca', 'a1a7c30a46a0ca4b86087ed7f96c36464be32d11f4dfef296dc4dd803a30b6e1', '49735ff61991d6377adfc4d960ceb4a2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b67eeec80ead', 'sanjay.mukherjee390@example.in', 'Sanjay Mukherjee', '+918293750535', '4279-4993-3213', 'FJTPS1184I', '231, Connaught Place, Sector 11', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b67eeec80ead', '5e8ff079cddf77ed250e147653789e6add3b10d8d421e7bf9e2cc33c4a38d270', '2a8fbdec6e26dc072125c7ee44c4f2b4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_53b16f2b631a', 'sunita.bhatia391@example.in', 'Sunita Bhatia', '+918644705205', '2678-1733-5785', 'GRAPD2712U', '689, Anna Salai, Sector 9', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-15T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_53b16f2b631a', '9e9dd9c5b5dc3043856843fe08db9eccdecb1793d9528c920523ba869d187426', '95977d126d8785adcd387a4e5b71a7a9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fe9dc3a63323', 'tanvi.bhattacharya392@example.in', 'Tanvi Bhattacharya', '+918413841504', '4736-5439-3972', 'VZIPN2643Q', '720, Sector 17, Sector 18', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-01T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fe9dc3a63323', '1e2f2eaf9203c3e65128d813ff328f59fe53cb42c9f01168fea892bf4c54e98a', '80b715d1a40e7257981fb4f79c1b142b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d149ffe49d9b', 'meera.patel393@example.in', 'Meera Patel', '+918643828830', '5988-4577-9268', 'OSMPK3421U', '163, MI Road, Sector 7', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d149ffe49d9b', 'cf649b1ed7b5825350d493dafcd228cf8b87ab189d3fa9027fe2ff19c740d070', '3b336d39d1b4e7f06ab249490f1915cc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3e17be4c08a5', 'gaurav.patel394@example.in', 'Gaurav Patel', '+917587619667', '2618-8745-2928', 'QSSPR2499B', '420, SG Highway, Sector 1', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3e17be4c08a5', '819de9aa6da3b8e25fc1d3b60188461b0b05356b0ec71d2a66de4772444f8141', '037b11e2a1826ec21adafcc3e4f41354', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_77804b4dec6a', 'sneha.verma395@example.in', 'Sneha Verma', '+917790076251', '5866-1669-7891', 'VBGPX7087N', '728, Koramangala, Sector 27', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-13T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_77804b4dec6a', 'a16ea6c29c0d7ff2dfd116574081579116e7a7a98d9e5671e122ba35cf56ba8c', '5a17755f679227a6236336eb8fab0496', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c548c7bd7c6d', 'alok.kumar396@example.in', 'Alok Kumar', '+918496187651', '6854-5324-5575', 'YPLPG9279L', '727, M.G. Road, Sector 3', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c548c7bd7c6d', '463e42d49bae048461e6ece5612943862aedf85fad653b4f7efb7d184ba61d0d', 'bb667bb71e57a7151772fad5b3fb8a0d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3f8ac555a689', 'meera.singh397@example.in', 'Meera Singh', '+918787834807', '2862-3646-9030', 'WOIPY2651A', '378, Koramangala, Sector 30', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-07T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3f8ac555a689', '17084e2bebb07e1bde77973190113088ce23a0e4c30e8be2543638631f7df9e3', 'ae7f6d40e837536b13070423bca87e4d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bf5934555348', 'isha.bose398@example.in', 'Isha Bose', '+918446368668', '5018-7308-7632', 'RRIPS8939U', '7, M.G. Road, Sector 13', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-20T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bf5934555348', 'd8b8a0da58c7cc2f97acbcfe36858c384dbbcd41d21787517776a1ba8ec6369a', '9e7040244ad558365e2ccf7abe97ce07', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2df26e9c6a59', 'pallavi.mishra399@example.in', 'Pallavi Mishra', '+918863091090', '5765-5964-8553', 'WUUPI4172Q', '866, Anna Salai, Sector 15', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2df26e9c6a59', 'd6b65fde15f5ca63c6baeb66d5cfa435eb5a2dc8c232706eb21b87bc02d0c450', '63af9b531031c61adc50742e6982d66c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_61c41c7c2f21', 'siddharth.joshi400@example.in', 'Siddharth Joshi', '+917254799940', '9172-5570-2645', 'IFCPF8321N', '556, Park Street, Sector 6', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_61c41c7c2f21', '06da41e60459aac6fe764ce8ac8cf835bdf3632bb8eea86bb3d5b920f11ac855', '8bb096fa2bb3b1709fbf999708efcdf1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c635d9548671', 'vikram.reddy401@example.in', 'Vikram Reddy', '+919578814473', '2297-4833-6090', 'QXEPT0569C', '600, M.G. Road, Sector 2', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c635d9548671', '62ae377db0296209d6aaf050a21d76d82bb9cef5f19832c6e7209277bc533589', 'd35df91d36b4514cb448481cef9794d9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_707990444399', 'priya.mehta402@example.in', 'Priya Mehta', '+918303342215', '7609-5192-1804', 'TOHPY0472N', '230, Koramangala, Sector 21', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_707990444399', 'a2ccf47d79f8dad93969d635a14a950c2a4974b9b30aa2c1cae09f3fd8a25dbb', '6a97494daa1ee2f5ad0cdfcc5b1465bd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9f8a3a3d1cb5', 'simran.bose403@example.in', 'Simran Bose', '+919518156211', '6666-1728-3799', 'DHJPP6439X', '910, Park Street, Sector 45', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-26T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9f8a3a3d1cb5', 'b29253101d962eef8ea7124cc8ca170561128a00e53a38d5cf52cbddbd625ed3', '1dfcf6480b2b821acd869fc57543f58b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_28f7dace1da4', 'deepika.pillai404@example.in', 'Deepika Pillai', '+917324632079', '8365-9250-7822', 'DUVPY3437Z', '806, FC Road, Sector 32', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_28f7dace1da4', '892afa7a3e1a48e2e786635d6b4442d6cf9878dd5fe33b7db51528eb3d36fed1', 'a560b5a744d4a6fb673c63e7c68f7c2c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ed183424f4d9', 'neha.deshmukh405@example.in', 'Neha Deshmukh', '+918922048272', '9831-9866-9318', 'ANCPB2634F', '584, Brigade Road, Sector 25', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-12T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ed183424f4d9', '1427e10dd5ba875ef42b6b621c4bb73618834aeec908096a6e437724be606543', 'fc526d6d6ef6458c168bfc2ec7c2cb4c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_138d95580c3a', 'karan.chauhan406@example.in', 'Karan Chauhan', '+919686348325', '6561-7125-8310', 'CJGPK5159I', '398, Park Street, Sector 30', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-19T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_138d95580c3a', '2a8df80df0d39489b02c05f4065738a1ad5981bbc54a499e4919d0d07f0c5d8a', 'fe062d2b20872de6e45f40846c9d0c50', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d04a81066707', 'siddharth.malhotra407@example.in', 'Siddharth Malhotra', '+917243417622', '8735-2245-8121', 'DJQPQ9799O', '154, Park Street, Sector 39', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-15T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d04a81066707', 'dd7141f3e087c65e6059f666f5530ac603a0902716b01a9cd13b9e469fb5838c', 'b8733f70e2b083aa7683ffbca6e3c4c5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2d119cef8c1f', 'ritu.malhotra408@example.in', 'Ritu Malhotra', '+919587359638', '3738-4410-7437', 'ITGPZ4994J', '685, Connaught Place, Sector 32', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-23T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2d119cef8c1f', '6f00e8a39aad7056d9dce6d101363546fe3da0a5d6efaede6e30e7bc0b952df0', 'a3cba4ba9ae08a9c9b70fccf40bc5e86', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fd62165895de', 'abhishek.mehta409@example.in', 'Abhishek Mehta', '+917574116257', '7708-9456-1505', 'TXYPK8845V', '278, Anna Salai, Sector 8', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-28T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fd62165895de', 'bf63f81172f5451287592ad5fbcd89ae4045fd25df93373f1709956dcc940f05', '1b2ca7eebd4006d1466dcea05b9c8455', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_21031a492d8b', 'harsh.malhotra410@example.in', 'Harsh Malhotra', '+917625250183', '5234-9001-7827', 'SECPM3499V', '312, Koramangala, Sector 31', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_21031a492d8b', '3588643af541462a9e35ac86417d7a4cb6af10709944ddf5bab95ae9544246be', '64e47cd7b42257e4758ff7bc7272882c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d4734ccf7413', 'varun.chatterjee411@example.in', 'Varun Chatterjee', '+917665738836', '5804-7940-3777', 'BEQPD3947P', '590, Indiranagar, Sector 38', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-14T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d4734ccf7413', '0f76fb43db9716b8a988837af64256f9d43ee0d502c69b922487344671250662', '830148a89c7a7edb2853d7f606b16761', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5b44cdf5c3b9', 'rahul.mishra412@example.in', 'Rahul Mishra', '+917814675347', '9378-9038-8105', 'BFRPV1215H', '536, FC Road, Sector 20', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-13T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5b44cdf5c3b9', '98bc2f5d2dbcce4bd1540f825ebff3f28442ab73ca83b8d7ca11772e6c5b9e3d', 'a16fd63a81cc1edb25034ee5c9231e5b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d6d8265a5d82', 'sneha.gupta413@example.in', 'Sneha Gupta', '+919486525917', '7506-2003-7187', 'OQGPV8340P', '427, Banjara Hills, Sector 34', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d6d8265a5d82', '3dd042ffb7a6b341c4ae572003d8af36f708334a2adafbf1d50fd0e596257864', '3e1ba7265cde11549041a3063fbf3fb4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3b873f8f265e', 'arjun.bhattacharya414@example.in', 'Arjun Bhattacharya', '+917367249785', '6094-8545-8820', 'WNMPS7876B', '869, M.G. Road, Sector 37', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3b873f8f265e', '184aedf18f2a976edbbed0a2ce25acddcfb63b3d19a1c118440ad07eb673a4e4', '9a17a21b85805646aab8aa6dfc38ab93', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fbcccf41ed9e', 'deepika.patel415@example.in', 'Deepika Patel', '+918903412205', '6523-6917-7070', 'YFVPN1003W', '229, Koramangala, Sector 15', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-14T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fbcccf41ed9e', 'ab6e890e70ee3234d88663264a2e71ae40af8c962312b21853cb082d43e76a63', 'b890d6277dfcd375e42f41969761d3c9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a73520d3da5f', 'shweta.menon416@example.in', 'Shweta Menon', '+919338400432', '7938-4151-6216', 'NFTPW1109P', '65, Indiranagar, Sector 32', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-17T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a73520d3da5f', '10398e2dca3561456089cfc96a727dee770d5c929d66708a75c6a18c886da49a', '428f6f41d92736d74e029258d6c19c7d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0cf6e6652c3c', 'ananya.mukherjee417@example.in', 'Ananya Mukherjee', '+917439654697', '9991-8279-8074', 'ZDEPM6838Y', '674, MI Road, Sector 3', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0cf6e6652c3c', 'f9657e3ba1395fdd7ac8964691c951660f33ed3d61b9110bf0d269495465c7de', '356f0948132e03c5eccdedb984b68558', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_da82a53c8d1d', 'ritu.verma418@example.in', 'Ritu Verma', '+918625456011', '9348-2388-6902', 'FZDPD0366O', '730, MI Road, Sector 20', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-21T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_da82a53c8d1d', 'e3da52eb4a5a4dc9c92800871c37676b05aab69d5adae8a133a7827dfc454992', 'b8a9810aef419d5776530289b9245a57', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c5559e6e77a1', 'priya.joshi419@example.in', 'Priya Joshi', '+919692567589', '2654-1908-8395', 'MZFPD3827A', '596, Anna Salai, Sector 32', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-29T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c5559e6e77a1', '910c55ab20dea13c3621d1dd0fb71f3b008a5d75a6e832036a137c928304b6dc', '5b07516fd5af4aee1af95ca14c89e6b2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3f78bf1c6f1f', 'simran.reddy420@example.in', 'Simran Reddy', '+919475974530', '6021-4107-4390', 'BGGPK3241F', '319, Banjara Hills, Sector 23', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-20T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3f78bf1c6f1f', 'aee8333d2680431eb2f8c2eb04f9f29619a9754906d6c5b40f1db19e2a9f2187', '8fa890297021af0a33c49227493b5ede', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_067981aa1ee1', 'aditya.sharma421@example.in', 'Aditya Sharma', '+919436992728', '4459-2493-8584', 'MBJPY1362H', '808, Anna Salai, Sector 13', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-11T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_067981aa1ee1', '399e42c554e339605e32f280500f21c69060310c4a6750b47b70ff8eac9e811a', '7113d363d20837a2005d738f4a27fc25', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_15189c6795f0', 'arjun.iyer422@example.in', 'Arjun Iyer', '+919975549419', '3147-5003-7411', 'IGPPC5532A', '100, SG Highway, Sector 15', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-12T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_15189c6795f0', 'e4e14fd79cd02a779e73c45497ab9a9cdd78d1acb3280bec4b6d970344803eaf', '9c828fffb516c4d304ecbffccac5e61f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fc3d58bc7da6', 'karan.reddy423@example.in', 'Karan Reddy', '+917353357533', '5817-8887-4879', 'GVMPB7627U', '196, Banjara Hills, Sector 17', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-13T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fc3d58bc7da6', '5ddf056ce8053e91adb8b675db9e091d4fe7c132882408df450e2b2a37886f54', '4f01a79c4f7bb1519a898f4ae845079e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_04338228415a', 'simran.patel424@example.in', 'Simran Patel', '+918743670920', '4480-1394-2693', 'AFEPV1495S', '670, Sector 17, Sector 38', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-24T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_04338228415a', 'dfd8dddb7731f279bda0dfadd828626fb2efd8767c618c7663708151e2bbf2e9', '2a644aff6a8e1a26d883b0ed93e8f53b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6b0dae4f6826', 'deepika.saxena425@example.in', 'Deepika Saxena', '+917921890890', '9723-4892-5227', 'FYAPV4494K', '647, Anna Salai, Sector 12', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-21T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6b0dae4f6826', '1980d4909bf9b53706be8bc79d055ac1ed81d3129ff728bf3b745df3f5df3263', '846d4914667f5e6201e5d4834c8a89c1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d0f7fc1be16c', 'alok.malhotra426@example.in', 'Alok Malhotra', '+917556467299', '3157-5623-4639', 'NCBPH4103F', '183, Anna Salai, Sector 31', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d0f7fc1be16c', '886741c2609ecfe994a9493d9f2f76a1d2853f07fe5c991c26db576a6880dbea', '422cc8b0382c2bae6b21291413ab8a96', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ccdc8e8cf56c', 'aarav.trivedi427@example.in', 'Aarav Trivedi', '+917461052137', '8470-9039-4186', 'JJZPW5271M', '732, Banjara Hills, Sector 41', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-31T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ccdc8e8cf56c', '82842f56cc773faf84e74bd1b88f87ca35665092b719c9f72a999f8b0dfa1781', '3fc63a528ae1fae1f447c41f3996ff7e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d236d27a68e5', 'kavita.kapoor428@example.in', 'Kavita Kapoor', '+918434473993', '8053-2431-3801', 'HYTPR6374T', '406, Park Street, Sector 17', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-13T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d236d27a68e5', '00f8ea4e25fae3ffc44bccdc4a846725deb0420e3d0c4756b0723af534256a55', '8c499d791e44ef9f75b2d93aa3662e91', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cfc14ff2bf40', 'ananya.menon429@example.in', 'Ananya Menon', '+917285589409', '8192-2214-2411', 'PXFPL1454J', '859, Park Street, Sector 41', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-13T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cfc14ff2bf40', '71bb6915fd2b01833b4fd3fe7305f598716af29c4523fcd7df94b2c2efa3d6c5', '485302cfd236b4ad4acef9fa786d6b03', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ba14999f181b', 'alok.gupta430@example.in', 'Alok Gupta', '+917785200759', '6184-5208-4088', 'XQAPG4486K', '172, Koramangala, Sector 9', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ba14999f181b', 'd8e85dbf3e688ebfe6e4e0d3fc6df68ea4f2122007c0e94069ee7098221b2fc2', '41aeedeeef94dbbf618ab3dc4c3762e7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0be7cdc50f91', 'tanvi.pillai431@example.in', 'Tanvi Pillai', '+919931200116', '8957-3905-4467', 'TMXPC4141N', '353, MI Road, Sector 14', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0be7cdc50f91', '68af88b59ae4efdf2fab890d3a441b55aea97ea6c20a4e31230410e743fde45e', 'd2b8299e0794def8de67503a38353d52', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0d774fac42c3', 'sneha.mehta432@example.in', 'Sneha Mehta', '+918460749230', '6399-3447-5451', 'AHKPX5885L', '390, Koramangala, Sector 7', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0d774fac42c3', 'e834abe2c8110a2f4e397d4b85f1404c5891657aadd63ffe5f390f76cc4be64f', '599c8a1ce6273a6d541715e96f042748', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9337492ba8d0', 'shweta.saxena433@example.in', 'Shweta Saxena', '+918179228933', '6606-5850-8544', 'LPKPB7297V', '955, Indiranagar, Sector 14', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-13T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9337492ba8d0', '2b660520cb8bf90c45817f26074aa66e55bebe593ae1b9391754b50c003c938b', '1471ca4e3766492a10febeb33c5482af', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0d642b2e8023', 'arjun.chauhan434@example.in', 'Arjun Chauhan', '+918844107730', '5882-1168-7036', 'TBQPL2903I', '601, Koramangala, Sector 3', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0d642b2e8023', '341e355e23b5e6bd70f8716b1f24477343d98197c032dc5c619d64be53198c16', '99f55f2e2ac46625caee9e54e07d4b67', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2d281b80e436', 'siddharth.reddy435@example.in', 'Siddharth Reddy', '+918518228346', '7562-1545-6369', 'LZQPG1194Z', '14, Indiranagar, Sector 13', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-31T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2d281b80e436', '2dc15b8cb1bfc716263d1dcf2abb907cd4554451738d6c2b87406adec73e4e7e', 'ff5cf94ce5121f8ec8dacdab1c3aea8c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a7622ba06ad9', 'ananya.singh436@example.in', 'Ananya Singh', '+919770791021', '7498-5687-5795', 'WKVPM4211P', '154, Sector 17, Sector 19', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.169Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a7622ba06ad9', '4a60e160522f5642ad1f91ad353335624f10d26b89565ebce0a73a79e34eb326', '94bb2dc8f910144b6ae055a1375742d7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_08f7ed9de618', 'shweta.bose437@example.in', 'Shweta Bose', '+918458291433', '9182-7262-6177', 'CJKPD6186S', '973, Sector 17, Sector 30', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-06T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_08f7ed9de618', '119579edb597daf6dad01101288885f315ffba47f9a824ca01e51c0ed95f2e1f', '6dff540bee1c13a3a0c3c84d94c3bf5d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b2b1aa594e80', 'harsh.mishra438@example.in', 'Harsh Mishra', '+917541985526', '4097-2298-1650', 'QKMPC9280K', '442, M.G. Road, Sector 38', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-04T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b2b1aa594e80', 'cb82ac5d29ae3aa1e5f2f5242abb3920e8d1a3c795035a9b1d1fa87ba0b7cda7', 'b6ff5b1124b71a4ff2fc920526f8f64a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5cf494a3f1ac', 'simran.bose439@example.in', 'Simran Bose', '+917346780998', '8118-2597-4210', 'EFQPR8627V', '67, Indiranagar, Sector 40', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-03T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5cf494a3f1ac', '898d22e304444449b97f996b396b85fa8ee1c1411e681e60866d08f602b75bf7', 'c6504652e05a8c181310f7f70538dff6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_60c364b6511a', 'anjali.bhatia440@example.in', 'Anjali Bhatia', '+919418143998', '8745-8264-4489', 'RVGPI9895A', '621, FC Road, Sector 42', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-18T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_60c364b6511a', '7ab535c4ce63921f07d5813f8648e6e6fc6f79bf87fadd266281e4b977c82145', '23aba9dc29e76acffcb6d385c380da11', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_03a834140255', 'kunal.bose441@example.in', 'Kunal Bose', '+918811858646', '2958-8481-7665', 'JCFPT1214U', '182, Sector 17, Sector 30', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_03a834140255', '18bb1b919054c7bbad7064f052d62812bc888210e5219ed1b02f07969d76b10e', '06ce782f030bac4d7aa96938a663fd66', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5a01cc69361c', 'pooja.reddy442@example.in', 'Pooja Reddy', '+919375633442', '3633-2346-1437', 'IFAPF7681H', '759, Koramangala, Sector 39', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-19T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5a01cc69361c', 'de64952b90b750eda22db84779b3faaa866aa103cf3daa70c60d56aa5311682a', 'ef95ca311634d4a4f80f5e4522ea4553', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_353506b3f082', 'simran.reddy443@example.in', 'Simran Reddy', '+917342626012', '3076-7619-5846', 'NNLPR8181D', '83, Anna Salai, Sector 4', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-01T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_353506b3f082', '84b713abd860636d7b7881fe8008e1171b34c50665d62a00a7eefde8c6468b07', '1b08452e4513cab953b538b61fb55a4d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_88bff9179174', 'nikhil.verma444@example.in', 'Nikhil Verma', '+917767906174', '8249-5565-6880', 'LEFPR1252T', '931, SG Highway, Sector 2', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_88bff9179174', '097a3e5c8d5f547a7f52dfbed7a61521ef2ed2eb3297b680e36e1dbb12e77cfe', 'd7270ac0443c3957937aaddba94949d3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_55a9e16d93f7', 'divya.saxena445@example.in', 'Divya Saxena', '+919556233559', '7700-9027-1116', 'HFVPW9933M', '70, MI Road, Sector 33', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_55a9e16d93f7', 'de1b29efbf3bebeb24707c5bd3e9929ce2b2b2b00490d388275a036695a98cca', 'a5c06e74ae8ff2766bfffca6e6441a5c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1689c05e846d', 'rahul.chatterjee446@example.in', 'Rahul Chatterjee', '+919274512811', '5876-5467-9572', 'ELXPW6158X', '773, Brigade Road, Sector 1', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-17T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1689c05e846d', 'd35cf6654063d3c1583c91939a81ca88aec466e014bcba9cc4887160e93ada62', '81c8c14addc6cc222b2db7504015ab77', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_75c8ee153902', 'kunal.joshi447@example.in', 'Kunal Joshi', '+917139497932', '6784-4244-2352', 'NIVPC7813A', '184, SG Highway, Sector 15', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-12T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_75c8ee153902', 'fd16a43fbe0ee72b1d182fc7d389a675241bb047251d355ed27e487f4f3740a4', 'b1721b04bdf3f4c10b5eba4af54c7d06', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a79ca86c0533', 'nikhil.chatterjee448@example.in', 'Nikhil Chatterjee', '+917195797431', '2930-7481-3209', 'BYXPG2141A', '705, Connaught Place, Sector 36', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-09T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a79ca86c0533', '9ef8ecf70a16bbb385d8c55ff77a6efd140661acd8abfcb128388dfee97ee096', 'c10fb310c703fbbc47f2852bc29aaf0b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dc2ff9a37595', 'nikhil.bose449@example.in', 'Nikhil Bose', '+917723015065', '3761-5612-3318', 'CSPPQ5686E', '24, Anna Salai, Sector 20', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-27T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dc2ff9a37595', 'fb9583d43b37bb99732327afc3330b1b021e0d827f66467e4999ae8491878f2a', 'a71c80db1cf5f697b7bed2a4ec3a5f6e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_994640b21e0e', 'rajesh.verma450@example.in', 'Rajesh Verma', '+918703921996', '6255-3782-5577', 'NXVPZ4076V', '509, MI Road, Sector 23', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-03T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_994640b21e0e', '0a965f6a3a72be14bebe7c49ae2daf9e4365c1bc559db93b0ccba39593922b87', '96cab1cc931c5ecbe4be31de32802906', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3f41a8cc520b', 'karan.rao451@example.in', 'Karan Rao', '+917520762838', '3203-3014-2253', 'HWMPC2423D', '853, Koramangala, Sector 33', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3f41a8cc520b', '0e1c26c0073ba16bc6ab62e4e6240b1edff54684d820cda6a90b79de5e73d0b7', '3deec7829a1022969076fe860288a96a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9b81cd78fdfe', 'dev.mishra452@example.in', 'Dev Mishra', '+919550610332', '3267-2316-9139', 'ZPVPK5583F', '953, Park Street, Sector 18', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-15T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9b81cd78fdfe', '98542a4dc9a951d38e3ec00182d4db37a19804e84693851c93044ebaebdf67e4', 'ddcf8487859723f01584a1a987f2620b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b57743174a39', 'tanvi.bhatia453@example.in', 'Tanvi Bhatia', '+917284481164', '2799-7438-6935', 'ZTAPV1771N', '415, Park Street, Sector 29', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b57743174a39', '1bfe87a53550cee6ffa3a817dfde63dc4e5446f737bae255e3708dad08bf77bb', 'cfd39bda45b4137f1d26d8010b27d58b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_356cf063654f', 'sneha.mehta454@example.in', 'Sneha Mehta', '+917853767521', '2472-8820-3228', 'ORDPF4781S', '259, Indiranagar, Sector 16', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-28T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_356cf063654f', '3313a9a6cbc46903597caac5e87f0d7fe81004692d4526aa1bd9d217ed6d474a', '3b69117a9bd745f0aec041f01f84dc45', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2faefb62e729', 'vikram.kumar455@example.in', 'Vikram Kumar', '+918850248248', '9286-3175-4764', 'SJYPM2865N', '458, FC Road, Sector 25', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-29T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2faefb62e729', '279837c4825508015f80ef9033e435f850593b5839d63d15d388b00979b3f6c9', '5c683d2d74a815e1afaa61fc23635d94', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6150484f1ed8', 'dev.mehta456@example.in', 'Dev Mehta', '+919335524771', '4514-7764-2127', 'GGLPM9756N', '266, FC Road, Sector 5', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-24T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6150484f1ed8', 'bcbd8b04a5109ac65c60188c10cbbef70b4836eef487d8cfd8ba746d920c4375', 'ae4f105f2d74e1dd92e410d10ce1db86', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_17186b3ed77a', 'pallavi.bose457@example.in', 'Pallavi Bose', '+919228441249', '3562-1509-1585', 'NRLPF0569D', '46, M.G. Road, Sector 13', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-23T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_17186b3ed77a', 'fffde5a514d69fb5521210b1df74369d3bbf5f70344fd45819fa3618a3699a42', 'ea002a779fe0a6ec5f6eb8a655c361c8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_78c331e51192', 'alok.rao458@example.in', 'Alok Rao', '+919743737738', '7706-3858-9963', 'PWCPK9080A', '619, FC Road, Sector 41', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-22T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_78c331e51192', 'dc89b2c59b3189a01b2d7472341c916bd2bc149e1da14f7756fb1d1a7f513219', 'df9b4a7a529a80474dfc894968bf5bfe', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_086f6cd0b45f', 'harsh.bhattacharya459@example.in', 'Harsh Bhattacharya', '+918493002957', '6292-3125-4831', 'VIJPC0302I', '511, SG Highway, Sector 1', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-13T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_086f6cd0b45f', '1f509efb31b46ae0dd8e281609311e1ecdf9998df30a32aec850ca21861824d6', '3465b6b575123bb5739760d0daa98c60', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2174282a4991', 'abhishek.kumar460@example.in', 'Abhishek Kumar', '+919997186524', '6272-1280-9399', 'NWLPP6002F', '704, Sector 17, Sector 16', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-28T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2174282a4991', '42f3725931aaa461f4c2a2d2902f687d4ec19afbe86ada683b05f017be4a112a', '76dab0efe928bb93b283585b849078cf', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0c838483fe9b', 'meera.bhattacharya461@example.in', 'Meera Bhattacharya', '+918253147084', '5485-1401-1139', 'NQNPM4041M', '114, M.G. Road, Sector 27', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-25T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0c838483fe9b', '20d1a5780203ff1b1681d64c306c2e5832e6f8ac97a5b4ee5658941e9f983cad', 'd22fd530d1203f172cbc628c4873c814', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_370e36d88dbb', 'alok.kapoor462@example.in', 'Alok Kapoor', '+918488812661', '3056-2841-2933', 'DBPPK1305T', '35, Koramangala, Sector 44', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-16T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_370e36d88dbb', '4372dfe2eed085de5762baa8fa880f0816c68759fc44778b2f535070e085f211', 'b8c86a12a27a54a379ed60c921ec0840', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_67367a80ecee', 'shweta.chatterjee463@example.in', 'Shweta Chatterjee', '+919846302199', '9852-8740-1634', 'XOJPF8037U', '253, MI Road, Sector 10', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-10T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_67367a80ecee', 'f45aef5006c7a8e918e2abe45731123a0b29df0092df55d835a48d1fbc18572c', '49912671f8fed5ecf25fffea3b039a35', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_804b242f9bc5', 'neha.malhotra464@example.in', 'Neha Malhotra', '+919162980184', '6824-3532-8618', 'SNRPO4503H', '893, Park Street, Sector 18', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-12T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_804b242f9bc5', '9a9f5747dc2b37cdcb37e593dfc622b27f9b08325166e42f268b018fd394b30f', '28d18cd0611fb614e3e37fb35c9e1646', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4af70796660c', 'rajesh.bhatia465@example.in', 'Rajesh Bhatia', '+919938595479', '9361-5818-7280', 'IWSPR8014A', '557, SG Highway, Sector 42', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-15T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4af70796660c', 'c64974521c96575cebbd8544847474b40d227fbf6ae1211b7393012ff41ac30d', '52de208f90b52232d43703ac56cd9b63', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b20044dab5d8', 'tanvi.mukherjee466@example.in', 'Tanvi Mukherjee', '+919575118462', '7996-3529-6675', 'VSZPZ3856S', '692, Koramangala, Sector 4', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-20T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b20044dab5d8', '7ffb3dad38bdf9228fc4c5960ba04409c14642f51745f6675f103db2ed249e1b', 'cf5159a046b8e8d08766d2665f55f37e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cebb3b4a45e8', 'shweta.verma467@example.in', 'Shweta Verma', '+918800701501', '3005-4793-9622', 'YKIPP3480U', '540, Brigade Road, Sector 13', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-23T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cebb3b4a45e8', '0b4fc4606e831429f6e90f38bdfa8ed40a16b219c28bf5566ba149ce09f8fbb7', '96b1c548fef314e121a2929928fd047e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_816d7f8a121c', 'neha.bhattacharya468@example.in', 'Neha Bhattacharya', '+919352608433', '4019-8105-3398', 'PZMPO4498I', '302, Sector 17, Sector 4', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-11T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_816d7f8a121c', '8b941b5f832ee809c208d75dbc93cbdac64dfd21b9d926a6bc1a358beafe7f16', '96c554914c39409c72ceec6724335fdc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_203b0678bff2', 'sunita.nair469@example.in', 'Sunita Nair', '+919622135771', '8959-5557-9374', 'STRPL7162Q', '213, M.G. Road, Sector 1', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-11T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_203b0678bff2', '29b26dd49e2fcf5e4630d718b9ab1e7d1e6d1d1da4293c8d1f78a03388732491', 'b1392d917a4410a2ca7b2095bae200c0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3e791b44da7b', 'neha.deshmukh470@example.in', 'Neha Deshmukh', '+919517548907', '8383-7133-1252', 'EDLPD4168Y', '73, Connaught Place, Sector 19', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-02T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3e791b44da7b', '86eef6835580e29c2640c9c6f46db6ec404eaf56b2c720624d12eb1b54cff308', '9e46ca4bb74e20fd3c3c51f8ce7ad832', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c25abfd939c4', 'rahul.pillai471@example.in', 'Rahul Pillai', '+917933002113', '8108-2758-6291', 'FEAPB2796A', '641, Park Street, Sector 5', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-26T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c25abfd939c4', '19927bc5bab84d2d16477a3c3661925209a3fbdaa3eea18a4ba70103c9d280e9', 'ad8ff50d9ff0786b8b5b78826bff9b0e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2c17aa644646', 'isha.gupta472@example.in', 'Isha Gupta', '+917684178148', '3807-4015-4537', 'ZPRPD9357O', '57, Brigade Road, Sector 19', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-08T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2c17aa644646', 'fe5ccb9decfcd32596b66cbcacc344c776e46c1925873e6b22286788162c5c5b', '80662a65fcc39916d4e7bc7fa6393ace', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2558fd79b74f', 'karan.mehta473@example.in', 'Karan Mehta', '+918831799622', '7041-4858-7067', 'MGBPG5193Y', '2, M.G. Road, Sector 32', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-13T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2558fd79b74f', 'ea45ca20469506721843fe7f7f6679362abab3b135e877941ac0aeb578e54170', '701585e7ef413d1ff2e39f396fe3d041', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_81312bd0b219', 'divya.kulkarni474@example.in', 'Divya Kulkarni', '+919359094121', '8678-9545-4429', 'VXFPL2478O', '825, Brigade Road, Sector 6', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_81312bd0b219', '7da95b30efe6d745c6468a88cfafecdab2fb9c70e6f77b95ceb4a0587d7ff144', '10d0a0887a958ed32a6d8b8886077562', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8f53c13b6d76', 'vikram.trivedi475@example.in', 'Vikram Trivedi', '+918624826221', '5961-4648-5092', 'VWKPC6339M', '620, Indiranagar, Sector 44', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-24T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8f53c13b6d76', '2e3e28019532240aced37be9a143f0282e9ad0b5ef67266e1d3e4246aaeef46d', '2b76ab90d13cf30a4e5e25c9d7ac9bc8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cccd38f2dabe', 'gaurav.chopra476@example.in', 'Gaurav Chopra', '+917897665129', '7712-1396-1713', 'JOUPF8615D', '751, Koramangala, Sector 8', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-30T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cccd38f2dabe', '0b25d7020803572f32363b95de42793d2bee0b022616b17b9c187906c3e33bdd', 'e11d68b5a63253140701bdf932906721', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_78c373ea6be7', 'ritu.kapoor477@example.in', 'Ritu Kapoor', '+918433020440', '6851-3665-1610', 'HYOPA2837J', '952, Indiranagar, Sector 5', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-02T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_78c373ea6be7', 'b8b67714767b345b644c2c315f6ba4074ae2b447676ca538f943046789e57db8', '471b2dd7cdb9834232ee588f14fcf85b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_570e8659f79d', 'kavita.nair478@example.in', 'Kavita Nair', '+917604905664', '9210-4382-5394', 'ISDPD4907E', '986, SG Highway, Sector 39', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_570e8659f79d', '788ee6738d0a4769f07af80ad7728ccd76272d18b6d23695c454ae4bef6d38b1', '8212feb41f3a7d4ed7d92f4069b63a45', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4843163ade73', 'karan.singh479@example.in', 'Karan Singh', '+919580258207', '7297-8206-5696', 'FCJPT2235F', '336, FC Road, Sector 43', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-28T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4843163ade73', '331d31e2c50d632f67159791c4d9f7fd75f3903592bf25e0c8f5fa2dc6672dc1', '512acf1781aad2fd231d5da8f80ed035', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d5edbd0c3b4c', 'amit.saxena480@example.in', 'Amit Saxena', '+919994462817', '7199-8191-7192', 'GWYPV0885I', '89, Banjara Hills, Sector 35', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-07T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d5edbd0c3b4c', 'eb5e92bb4bc395942a738dd46abda21defd69e6eea797a5f00c2d67073c3c362', '11ef68fc4045bef0666f3f1c59c11277', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_79acf03ddd5f', 'karan.malhotra481@example.in', 'Karan Malhotra', '+917582857227', '3399-8906-6160', 'UMQPC8882O', '937, Anna Salai, Sector 32', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-04T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_79acf03ddd5f', '347404fbe2d42eeb6d9f9a1f38d64bc124c0e810b6be1c04f9ca5508c2f18d56', 'f8618b2bd796fcb193c0da4ff0421607', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a47a02fb9198', 'alok.mehta482@example.in', 'Alok Mehta', '+918532938006', '2904-2833-8487', 'ZZEPW9778Y', '771, Connaught Place, Sector 25', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-17T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a47a02fb9198', '5ba53932ebe3d0e2b564feb7d50836253eb782f5308a846f731e4b95f4598bac', '52ced3f450631d0f98242d6eb2481362', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_97e0f1d2f3ea', 'gaurav.deshmukh483@example.in', 'Gaurav Deshmukh', '+917547017389', '4506-1661-2271', 'QRNPE5201X', '535, FC Road, Sector 42', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-16T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_97e0f1d2f3ea', '25f72099938b14f482d6b5ceb8a7ecfb1fa09a21b6cf238933a971996b2005aa', 'fdbc4cbc20609ddd627837ec1fae2f33', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_67b3be39dd3b', 'meera.chauhan484@example.in', 'Meera Chauhan', '+917589612727', '7040-9863-2549', 'MRJPA8782D', '252, Banjara Hills, Sector 5', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-01T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_67b3be39dd3b', 'f584bf1e34a7110b2fc19f0b2b43f1e8e006e2307f8356094e346a31697513c7', '23aaa5ba792b7577f26b94bb4da27638', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b8208e3248a1', 'aditya.mishra485@example.in', 'Aditya Mishra', '+919879245112', '3518-4520-1560', 'KMGPE1566N', '729, Sector 17, Sector 22', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-18T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b8208e3248a1', '3a401696c5021211f2a93363d2fecc72e82110aea9a754cf77952a2ece797595', 'b9cd5508e4f1ac1a1392dae14aad79cb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b5359b3954df', 'nikhil.gupta486@example.in', 'Nikhil Gupta', '+918858692478', '4740-6790-4717', 'RYSPF0139Z', '840, Connaught Place, Sector 3', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-11T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b5359b3954df', 'cebd973ff8cc1df5b42e49abdc5232f181beebe3a3abe07cb5c6ca08ff500359', '4e6e742180d4fe36d9dbfd1f9f58e93b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ca1cf008a747', 'amit.chopra487@example.in', 'Amit Chopra', '+919621516834', '9971-1977-3904', 'SWVPH5273N', '697, Connaught Place, Sector 2', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ca1cf008a747', 'cbd9930de935ae12a5892988a22a8ea599ae1adc26c32715be10332c9176fc7d', 'c5799e4012073800deafd5c9d017c336', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c6deba583618', 'ritu.bhatia488@example.in', 'Ritu Bhatia', '+917181985728', '5637-4529-3486', 'NOUPR6821D', '44, Indiranagar, Sector 15', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-23T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c6deba583618', 'f64bfc8aae1c5b69b697a9c59a45aa403eeeaabcfff52483b6b31e816f223081', '4295e8f3f3bcf747b4824329570d4765', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_06931e2d9934', 'neha.dubey489@example.in', 'Neha Dubey', '+918288780063', '8502-8192-7391', 'UEXPZ1422F', '302, Banjara Hills, Sector 3', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-25T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_06931e2d9934', 'bd2973a9efbb76d3d106c6322ed9a68c34516d6b4a766aaf9ffc282be64a2207', '4c19d979ade5170f7331c892aa67f617', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9dbafc4d64ab', 'harsh.iyer490@example.in', 'Harsh Iyer', '+919497082239', '7382-3651-4293', 'FSWPX8856U', '790, M.G. Road, Sector 1', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9dbafc4d64ab', 'eb2e176b60cde16412270f3fde3a2268e50a6378cb8040d44fc82e98ac21bb08', 'ae1b295b25a337385da5bceac6ac5d72', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3f376dd706fa', 'simran.menon491@example.in', 'Simran Menon', '+918188784464', '5845-7681-2367', 'HSLPZ0214H', '556, FC Road, Sector 26', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-23T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3f376dd706fa', '2b52abb4186c6d9fae82123c546596575cae584ceab648514a23ace720b43e2e', '96f772094863927a3cf82ae6d5d46a72', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8ad7b22e20a5', 'amit.chopra492@example.in', 'Amit Chopra', '+919627641179', '8352-2040-6926', 'HADPS1565H', '561, Anna Salai, Sector 27', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-11T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8ad7b22e20a5', '1deaad60eb2c03e23128cb6083002737eb56dd66dcb655e3d2bd90d1a6d52a91', 'b10d4ae47d565917744e93a6c26a6f34', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_72ef2a2da4d8', 'swati.bose493@example.in', 'Swati Bose', '+919788870530', '6563-1119-4454', 'SEAPU9343N', '71, Connaught Place, Sector 43', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-25T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_72ef2a2da4d8', '7c04e2f73bc4f65becc0fc22d4e0c82bf0b1202df14023153ba3ef23c5e2a1db', '3dba25c2b670dcce72b38eed6193d106', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a9f392d1ea0b', 'ananya.mukherjee494@example.in', 'Ananya Mukherjee', '+917442002504', '9724-9272-8377', 'ZKNPO8711U', '969, Sector 17, Sector 24', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-04T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a9f392d1ea0b', 'f1c19552d11e3edbf32317fa37aae0c8f7221731df7bfad36d6fa08ebf7fb120', '42aab9b7c1f9621947ca609dc73ff729', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1d3bf715b01d', 'rahul.kumar495@example.in', 'Rahul Kumar', '+918658181726', '2649-7228-1552', 'ACIPR4489J', '61, Banjara Hills, Sector 44', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-28T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1d3bf715b01d', '1d755a72816815f133a37f16dbbcec66b57a7aab0900e067f5b6d429788fa96e', 'e9a768879bf0dbdd1df8e43852098d6c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e63fe194c092', 'gaurav.menon496@example.in', 'Gaurav Menon', '+917354139609', '6657-2082-8769', 'CUUPX1392X', '247, MI Road, Sector 11', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-05T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e63fe194c092', '25cac745d24cf6de7f2ec42c7a679c0322503ee3040263a7cb0608afb0686b0a', '51d0497e9b6e2483028fc15e064cba0c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_727341561f68', 'rajesh.kulkarni497@example.in', 'Rajesh Kulkarni', '+919605633838', '4138-3943-1404', 'VJZPN2749U', '404, Indiranagar, Sector 22', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-28T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_727341561f68', '3fde48acdbbf232755b11c3bc4f46691cb35c9c9595a8fe4a79b275444b19f85', '73b908d890b913d0371fa682a1aa87e2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_eb6c705c6841', 'priya.mehta498@example.in', 'Priya Mehta', '+918979809741', '2497-2760-8057', 'UYOPT8150J', '198, SG Highway, Sector 32', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-28T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_eb6c705c6841', '1393a4469c38ca3959bbabd3a1f3c8ae69847af9719d5c62c1ac712233caf018', 'ba3950814aae696bc835d4f809adea43', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f46ee16b982a', 'priya.trivedi499@example.in', 'Priya Trivedi', '+918800270505', '7740-5538-7514', 'NVDPS9406B', '229, Koramangala, Sector 3', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-30T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f46ee16b982a', 'a57f057a1ddf781aa554f8990b2cf9ecbaa4cb42572524f41249f1c98c9bd8bf', 'ca4286eb651e791f99ca5c20d0409390', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a1a5f5ec9508', 'aarav.trivedi500@example.in', 'Aarav Trivedi', '+918100664705', '2900-7927-7329', 'BTVPS3739N', '81, Koramangala, Sector 21', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-28T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a1a5f5ec9508', '4e93f17b9a3fd34c813290f39641027f4231564ad70cd5e621493c22077bf68f', 'e765c4be67cb7bda8d30f98894ea9109', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_089ce41cb6af', 'deepika.verma501@example.in', 'Deepika Verma', '+918713715166', '8774-6096-1876', 'NTGPP8318S', '880, SG Highway, Sector 4', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_089ce41cb6af', '3cb7235650008960139fe7738cb150f0e419c766c056805abbd81a9090ac309d', '56969ad3cc527d9e63b697f1aa0bf912', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1a25c38409d2', 'bhavna.verma502@example.in', 'Bhavna Verma', '+918307888960', '8650-8261-2803', 'VBDPI9482V', '595, FC Road, Sector 13', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-30T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1a25c38409d2', '44c5c05ec4a1732de3cfb3f1fec829a03a8982ae3805e03cd4ccf302be619b17', '2c9701cfb043aab108d474be7a27268c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d48d25e1b884', 'swati.pandey503@example.in', 'Swati Pandey', '+917217535668', '4917-6047-7450', 'FXEPD7816I', '970, Sector 17, Sector 23', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-05T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d48d25e1b884', '5a9132bc5f7fe9fa1d398e97e8bfadeacfb9732821d235efd7155a04ad297159', '442c6b69fb58197354408bfadfa124f3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c851729541bf', 'priya.chopra504@example.in', 'Priya Chopra', '+919786819650', '4188-6572-8411', 'KGHPN5353P', '428, Koramangala, Sector 42', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c851729541bf', '14dfe59f608dff41c39801884f362bd92a298bf3bcb5bd3752abb1c842dcb8b9', 'dc8f8c2af27e0a0b7b9f8e6762f04d41', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5001ac319bfb', 'sneha.patel505@example.in', 'Sneha Patel', '+918557044751', '3235-8329-6219', 'BDXPY2788R', '10, Sector 17, Sector 40', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5001ac319bfb', 'c2763072b1f38a252a4c57b40c6de338eca42a4e9ec78f56fbc8245d6e740c48', '1cfeae4f58881d32df9a3de1d09378d1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c787cea36c10', 'isha.rao506@example.in', 'Isha Rao', '+919382157571', '4020-6611-5719', 'ZXVPR0184C', '816, Indiranagar, Sector 2', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-07T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c787cea36c10', 'b677c937c38876bd978e1098dc21f91672bd9a049b4db5111af7c976ae13f36a', '7ab526bc1981e98de885b1d098a01342', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6f28a87900c6', 'tanvi.bhattacharya507@example.in', 'Tanvi Bhattacharya', '+919379130413', '5568-8881-2903', 'DSRPX8350E', '887, Sector 17, Sector 23', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-11T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6f28a87900c6', '6b2f2e779b3ea086cbf4fe3660e1150d9fa9ce7bfaa97a2f4f207e78e6a56ee9', '109fb076892f31534c5e3584d3eca907', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_21a57175ed42', 'meera.saxena508@example.in', 'Meera Saxena', '+919994544015', '7114-6148-4701', 'FXFPZ4208Y', '29, MI Road, Sector 14', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-17T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_21a57175ed42', '8508608fe01ed5759766c7e9c50df2b16aebccb19a8f0b0c1312ce6ffdf637c0', '73e7ae4607671e0cdef707a2acaed4f0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b5521b90c5ad', 'dev.singh509@example.in', 'Dev Singh', '+918314283477', '3043-4994-3707', 'HLJPN9692Q', '154, Brigade Road, Sector 15', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-27T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b5521b90c5ad', 'a60341104cc876da34a554bc877d0b3d616bd9a162206c8f71476cb05e81373a', '6384210662cd0bf630f497ab2ab4e5ec', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c4f4d2eef464', 'gaurav.deshmukh510@example.in', 'Gaurav Deshmukh', '+918469012701', '9158-3570-2773', 'NNHPY2851I', '745, Koramangala, Sector 23', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c4f4d2eef464', '70da4629d4fe835079468792cb599301949b6471e0803728bff831c4445f9d54', '268d6f1a9b0691e1a8e85d3a19745036', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a053ea1a7065', 'divya.bhattacharya511@example.in', 'Divya Bhattacharya', '+919149117065', '7795-3792-3229', 'ULMPI0841Z', '3, Connaught Place, Sector 8', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-15T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a053ea1a7065', 'efb732908430a2f53531f5691f0b7de0044d15b1923ec21d2dcdd62827dab3bc', '6d59d5448f6028124e56de620edfe1d0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1508fcb110d0', 'neha.kumar512@example.in', 'Neha Kumar', '+917108409634', '4250-6201-9685', 'NNLPO7311N', '320, M.G. Road, Sector 29', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-30T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1508fcb110d0', '85efcf792c9572fdb37a7f3991254f0a455a3067e40602fee7fbf702f587d3b6', '3b67f6ac5c4ceb0770cd1dcc6ada61f2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2f551ffe1b7a', 'karan.chopra513@example.in', 'Karan Chopra', '+919129467257', '7970-9235-4117', 'SEVPO2370N', '489, Brigade Road, Sector 7', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2f551ffe1b7a', '068d4aafc50889f656fb032517b1079f69538b784710ee70475c4b531f1a5d7a', 'd4af7255b9e0b445ccca115a7a28e46f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df6a346d3305', 'alok.rao514@example.in', 'Alok Rao', '+918153969665', '7241-6795-6846', 'YKUPH8966N', '261, M.G. Road, Sector 18', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-27T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df6a346d3305', '0355044cb30c02c8cf6a1598c3f695c70a68e75b65eebce6a2617a40bcaf3a06', 'c543b609e23756f0290fd2ec9194fef0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_42c316c19dd3', 'rajesh.sharma515@example.in', 'Rajesh Sharma', '+919843928496', '5455-1848-6712', 'WJLPJ6704Z', '998, MI Road, Sector 12', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-19T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_42c316c19dd3', '0b900b2fb30f297e8841bd5736d73a7144860a07ec0eaccef0cacf060d5299f2', 'eeb2ae80b7ceaeabd75cec2c49a57ab4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f2dc05a30c14', 'vikram.pillai516@example.in', 'Vikram Pillai', '+918725938484', '6336-2084-1410', 'ILGPP8367D', '387, Anna Salai, Sector 41', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f2dc05a30c14', '2d3ee6368a7d7f91141009b358a880450acaa069d8b4118f3701b59c0c407bd5', '013952ca67627936e1717e70ecd2197c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_30693fcdf627', 'abhishek.trivedi517@example.in', 'Abhishek Trivedi', '+918480618000', '6058-9914-7905', 'NQEPQ9137K', '749, SG Highway, Sector 43', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-25T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_30693fcdf627', '0c9d435c8b6a7b31c7dc3bc209eae6e58d7f61d5bc7fcb87e2ad1c3475e5414c', '2a16682481166495dc689a79a913c172', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4efb082d27e8', 'rahul.pillai518@example.in', 'Rahul Pillai', '+917282149117', '7105-9513-3642', 'RAEPQ2636R', '285, FC Road, Sector 39', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-04T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4efb082d27e8', '48357a6e401dd9efa3635051dd72a603e78596beb5803055d81c9ba6bffe8a75', '0a36da24e5c457edf8fbc54fd6c43948', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e6795deb5c71', 'varun.reddy519@example.in', 'Varun Reddy', '+918942060485', '5393-4133-6088', 'SARPD0371G', '42, Park Street, Sector 33', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e6795deb5c71', '67fc99132d0eec7791e5624a6ff20ccef303858c7c468ac33f1f0b6a6037d4f5', '4c7a150ad20484a567475cf96584b7cb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6ffe7e1eaa52', 'pallavi.kapoor520@example.in', 'Pallavi Kapoor', '+919268954525', '7499-2607-4739', 'ANZPQ9985V', '398, Sector 17, Sector 20', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-14T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6ffe7e1eaa52', '8e6f2ea02fb2d1370906d21f58a9c57b0544acee954587467a1a06f9fefc92ba', '1f17a2d6b7941c8b598983c69cef30e0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aeed580533af', 'dev.malhotra521@example.in', 'Dev Malhotra', '+917588927745', '6221-9460-6890', 'GOZPG2234Y', '740, Connaught Place, Sector 44', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-23T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aeed580533af', '1aca2e76278169395da1810640a31eee262c3e39b8c25afe876e4bc94c4a6843', 'b0d67df7ba044b304d4c70235ed28cf0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4473ef6b3aa8', 'kunal.bhatia522@example.in', 'Kunal Bhatia', '+917761838076', '3195-1952-6936', 'XDFPN0127L', '536, Banjara Hills, Sector 44', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-18T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4473ef6b3aa8', '08e05e4d94de87f6db9865ed102e3a16fc1340d7dd651b647ce9010167ce4868', 'd527fcdbc0274f8447902531b38c62ef', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f291877d0746', 'pooja.reddy523@example.in', 'Pooja Reddy', '+919199498126', '9045-9288-8349', 'FUJPQ6455S', '390, Anna Salai, Sector 3', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-25T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f291877d0746', '710f1d87cfc6b5e0e95a1fb8ef9eba7cb3f3e4b3a6c8d87972db522b49c5b459', '7ffc0f8b65bc842f8df37d65e51aa6c5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5eeec56d65e1', 'arjun.gupta524@example.in', 'Arjun Gupta', '+917822413113', '2418-3352-6991', 'WCLPE0793Z', '335, MI Road, Sector 23', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-29T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5eeec56d65e1', 'fbab3f7f073801315c6f6c25b6fa8c25c163544071e3eb8503c0fe3e42d13c17', '3315eaea469027b934e23b7399f3ddcc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_552c8262f6bd', 'rohan.mehta525@example.in', 'Rohan Mehta', '+919165446616', '9522-6285-5772', 'UEHPV8752I', '335, Koramangala, Sector 39', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-26T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_552c8262f6bd', '9c35485c9a740a9f0bb3e267e32f079520c3a037e04e294483074408be687451', 'eb3cad7df442e2540e2704b408d9350a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e8a2a4e33f1e', 'deepika.iyer526@example.in', 'Deepika Iyer', '+919559811016', '7430-6341-6792', 'TEHPJ6031H', '747, Connaught Place, Sector 42', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-27T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e8a2a4e33f1e', 'f75982884d119a1ae3f5e616cf89997e42cd2bf663b5cfe682e110744bb412f2', 'a0a0139a14bde8e20e7d1f8c5f117a70', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9b2cbcc0d9e7', 'manish.chauhan527@example.in', 'Manish Chauhan', '+918243914608', '9642-4901-9139', 'MMYPF4894O', '890, Park Street, Sector 15', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-04T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9b2cbcc0d9e7', '270c6c953c48c17e299108369d4fe7bd363903664e60dd4b44b3353e3b50b3c3', '04004381a673748e9ab4ee94d27d8aa9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_85296549f3dd', 'manish.mishra528@example.in', 'Manish Mishra', '+917634732835', '5600-9697-8406', 'LDNPW7887N', '63, FC Road, Sector 6', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-27T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_85296549f3dd', '557faef58538d3216f91d516e8a37396d62ac7dd3e4f25219f9e12d85cd93e25', 'f2bafbb659dcd62105e2f7d6c829c361', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_05b8826e310a', 'vikram.kumar529@example.in', 'Vikram Kumar', '+918732533109', '6137-4390-9818', 'XXNPM6540Y', '593, Park Street, Sector 38', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_05b8826e310a', 'd4be95172f67a9b9f6a32cb27cc294ea9cc3f991219a71330851240810f832f9', 'c6d19308a3964be2209d49c686153a3b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9a8c235d4d86', 'rahul.deshmukh530@example.in', 'Rahul Deshmukh', '+917337621963', '5168-6330-8055', 'ETMPA5169A', '287, Banjara Hills, Sector 26', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-29T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9a8c235d4d86', 'fbf7f63b04237f1e8fde9051210e50ee6599c2aa606719993e057d0228c2a7a3', '031510f9b05a3be79bf70f5c1b126daf', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3cc1a46d8f37', 'simran.pandey531@example.in', 'Simran Pandey', '+918198483141', '6032-3380-6127', 'ZWDPY2659G', '312, Anna Salai, Sector 23', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-13T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3cc1a46d8f37', '2334e4c6c81be62eb3be9607e32cfef77022879f98bbd97bde61d179a42bb5ee', '1a8789c420f80d65c221e15e6c6a3df2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4fba74584219', 'rohan.bose532@example.in', 'Rohan Bose', '+917764463789', '6459-6220-4529', 'IECPY1786C', '187, Banjara Hills, Sector 8', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-01T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4fba74584219', '6b99e51c26da56c530f924572560af7eddbc8903576e602775fc2e85a82c38b2', 'a291af9ad48f7767d0d25f8ed1dbda25', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f6ba75924b8a', 'alok.mishra533@example.in', 'Alok Mishra', '+919713140161', '4251-7220-5635', 'XOEPJ1180R', '626, Koramangala, Sector 16', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-19T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f6ba75924b8a', 'ab3baee36e4cb4a86f40805a1f09788451e7e6871913c312a03b79bfa4dc3d18', 'fbd8ff489fd118c7808d5bc09c50e559', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_98d9177351df', 'alok.patel534@example.in', 'Alok Patel', '+917563474940', '4524-7570-6837', 'PFHPH1018O', '246, Indiranagar, Sector 45', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-14T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_98d9177351df', 'c63c45dd1502fd638451478f9b297f6ffeb26179906e1dbd1d7c00974030c6ce', '07c6d4b7c913543c6361001b9071c4ba', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6177016c60d7', 'kavita.kumar535@example.in', 'Kavita Kumar', '+917571144281', '4212-5082-4467', 'OJOPO8104L', '926, FC Road, Sector 8', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-11T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6177016c60d7', 'fab551a3e1444d873f6afdac43d02d85c58dca39ac9c4027b104fe3970ae0725', 'a8e96d69012c035938a7fcbf82288265', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e41937914ab5', 'pallavi.rao536@example.in', 'Pallavi Rao', '+917746435138', '7999-4449-6178', 'TTOPQ1693B', '473, Koramangala, Sector 32', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-17T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e41937914ab5', 'e240026acc1b7d727f503538497804cb3cde5f95b80da64417cdc32a971cd9c8', 'fcedab0dff9948efbc2034ad0ba819b5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_91592784d22e', 'abhishek.saxena537@example.in', 'Abhishek Saxena', '+917806295524', '4330-2850-3005', 'YXTPT0751W', '924, Anna Salai, Sector 41', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-13T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_91592784d22e', 'b61bd0809f94dd27011119c572247fb42ea49faec8cff4762767a37f655f99b8', 'db7bf01e375484f5f87fdfa1fe2bd691', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2e3e552b780d', 'arjun.kapoor538@example.in', 'Arjun Kapoor', '+919664202983', '9771-9158-4814', 'BIEPV9884T', '388, Koramangala, Sector 8', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-29T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2e3e552b780d', 'bd918ab0c01f7dfbf62053041654248bf5332bc3a1d8474dbdb7ac07f8b61fde', 'd47b84468e04861482753c66224fefef', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7a0174be0716', 'shweta.gupta539@example.in', 'Shweta Gupta', '+919590618450', '8222-5056-6187', 'QEVPC6548P', '354, Park Street, Sector 9', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-20T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7a0174be0716', '9271d05f926f70ff7838957e1e159e4856af216acdbabc1a615e52194947f525', '1c8ed2de2077a01279a1425f69d231f9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_715f07b334f4', 'anjali.gupta540@example.in', 'Anjali Gupta', '+918946695860', '4724-1576-1803', 'MTQPX9168O', '360, FC Road, Sector 25', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_715f07b334f4', '0212ef3518fe9ee7a4faac31b6b179d474dfd3a82ceb465c4f5920529de5407e', 'd58ff886b72599a294b909da848702a4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f616f59c5940', 'divya.rao541@example.in', 'Divya Rao', '+919888187137', '7664-7334-4551', 'SZDPD6563U', '816, MI Road, Sector 30', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-27T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f616f59c5940', '81d4f5b711affdba0d4ab353b88d57ea28faa11b725d7bb1dc01fbae1d15d8d0', '19a17903dbea958a45ab2d72b552e558', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_50ac06444e0e', 'tanvi.agarwal542@example.in', 'Tanvi Agarwal', '+919208963181', '2591-5936-9525', 'QGYPH3662O', '748, MI Road, Sector 2', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-10T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_50ac06444e0e', 'cfb28d1e1db612c95061a039d8d743d80344303c120cfc25280c158831555853', '1797851d3497701d6877f9ebc2873b20', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8c3b3a4d1050', 'anjali.bhattacharya543@example.in', 'Anjali Bhattacharya', '+917454394118', '3954-9718-1441', 'RNYPR2505O', '5, Sector 17, Sector 13', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-19T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8c3b3a4d1050', '30d6c31414d8a8c3e69e9edbe0eefd7239fe2efce5cbe7a324e84609a04dbe29', '90dc9b8e06c49313eb3fb7cfc8726800', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4dcfd9951953', 'priya.patel544@example.in', 'Priya Patel', '+919926043242', '5075-8390-4085', 'ERTPB1230C', '459, Brigade Road, Sector 41', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-08T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4dcfd9951953', 'eaebdf15094e9aa5407502e93f385eabe877ae893c87dfa54c0c204608bbaaa9', 'e7638cdb5743c88480309810305b20b4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cc259baca522', 'bhavna.chopra545@example.in', 'Bhavna Chopra', '+919226401109', '4388-3949-5433', 'BICPD4489F', '613, Anna Salai, Sector 4', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cc259baca522', 'd6c51e69b0959386836bd0cb8737f7d796f28a45a8c7c4744bafee4d2b750d97', 'bac0a0f6bfe93d0f08feb521650e1e0b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c3e855f13a38', 'aarav.kumar546@example.in', 'Aarav Kumar', '+918607722423', '4552-7126-1820', 'CVQPA9631C', '7, Indiranagar, Sector 12', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c3e855f13a38', '4e0250c658777101fcac4e863248aaea3c092b5a004bea76af89905c82fc025e', '0b832dab92220d36504e9a4b066b0a32', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e95cde7b82ee', 'aditya.kulkarni547@example.in', 'Aditya Kulkarni', '+918588274411', '6273-8657-6422', 'EXRPO7432Y', '111, Banjara Hills, Sector 18', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-04T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e95cde7b82ee', 'f2b8dd59ce103d1a20c2d2dafbed91ab76dee4268c261aaef0230399639050a9', '24fe6d9e294b79aa863512aa000cb614', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a2284734909d', 'priya.deshmukh548@example.in', 'Priya Deshmukh', '+917267690651', '4890-7351-5225', 'PBRPW0042N', '402, Brigade Road, Sector 6', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a2284734909d', 'ceb06b1b5ddf58218e600c4427475118967b7ea335e336dd5939d774627abbb3', '14e324c118e457536c0e43f6e6752140', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_85c37ea922fb', 'ritu.joshi549@example.in', 'Ritu Joshi', '+919375428198', '7466-6583-3066', 'QVTPQ2590S', '76, Brigade Road, Sector 18', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-06T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_85c37ea922fb', 'acec85cbbaa14571f348cb5818f55624753014bacd4c3d988e8ef11b315a8ead', '7688b00fd63a02d38407d2716a5497ab', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4e935da30c55', 'ritika.iyer550@example.in', 'Ritika Iyer', '+918807658621', '3048-6177-9818', 'NWWPH4427F', '140, Indiranagar, Sector 15', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-19T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4e935da30c55', 'ddc7b89c24fd5aec10570e4093074f4fef0b49158d0f1fca8e05c15bcd81d8cf', 'afe3e2e8f17ffa39c449e350aaf2536b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c22d05e23f27', 'pallavi.pillai551@example.in', 'Pallavi Pillai', '+918867890061', '7916-8103-6637', 'WOEPT0421G', '129, MI Road, Sector 24', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c22d05e23f27', 'f024b5885c1c823ef4f9cad4d48f6ef4f19756b0c9066bbd1b92aa3c8dea721b', 'ea239d5d23d72ad38d87eee8f2a5a5c9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_57977d500075', 'sneha.joshi552@example.in', 'Sneha Joshi', '+917553083037', '7780-5373-7682', 'RKGPP7100Q', '425, MI Road, Sector 40', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-05T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_57977d500075', '2c4d70b290c40248fde32c70d09430c62e9196822a6a3c8691142cffdc7ff067', '64c8f12449928999d0cdf9fd5d344a54', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_393e10ff23fc', 'amit.gupta553@example.in', 'Amit Gupta', '+919523407380', '9462-8850-2731', 'RZVPR2960V', '70, Anna Salai, Sector 32', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-12T10:59:26.170Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_393e10ff23fc', '516054be4ed23531eacf6aad96ee8a96011c9b270f8de3fa43ee96d433e3c6f4', '3313585be200a60b66428f1563cf8c75', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c54bebe1207c', 'rajesh.sharma554@example.in', 'Rajesh Sharma', '+919480677959', '9984-7353-2173', 'VDUPJ7792M', '227, FC Road, Sector 13', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c54bebe1207c', '513d8ab582d9c37ed7951a08bf2987f236a468c93409baeb6f0ea4d904f9a09c', '2ff74b5832789f238c750ea24162742f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_796f8cccda6a', 'priya.menon555@example.in', 'Priya Menon', '+919139677812', '6291-1486-3721', 'RVNPK3635H', '561, Anna Salai, Sector 36', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-02T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_796f8cccda6a', '1e476d51e756e09972cef997c5d6d0491526ee57cc9888607520f65e697f3677', 'c7464e08c71f263933e3aa6c323f5a66', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f789001415e8', 'kavita.malhotra556@example.in', 'Kavita Malhotra', '+919602050770', '5725-8829-1777', 'NQWPV1749I', '565, Park Street, Sector 36', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-04T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f789001415e8', '2191b04f9fe15f84606f78c4b064a059055b0571917eb29d9bec19b278aaa192', '61f9345310944f5ed180671e831fa02a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d910ae29fd91', 'priya.deshmukh557@example.in', 'Priya Deshmukh', '+917526302477', '2830-4227-8492', 'HQKPB4643J', '503, Sector 17, Sector 20', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d910ae29fd91', '4ec03fa38c972c637102476a1e1effa61e713c25fda952e29d1be7af7001ea00', 'd9d73bb664914f6c53fd67cd4c3f5362', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6af8c93c1419', 'tanvi.iyer558@example.in', 'Tanvi Iyer', '+919504280411', '5243-5934-7735', 'KOTPB6387Y', '903, SG Highway, Sector 33', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6af8c93c1419', 'ac34f8611afb2bb2f4050650b0bf92441e64ef23f7ef86c6c19e88f2927f6dd2', 'cf254d3d7d4cda87029c8362e9028464', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e783839e3105', 'nikhil.gupta559@example.in', 'Nikhil Gupta', '+918411503084', '8869-3567-9290', 'FGSPQ2621G', '83, SG Highway, Sector 29', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e783839e3105', 'ed6bc15d83a1ad534613f4aae839642e0c05dd8697140a9292c7a033d375cbc1', 'e7108f47ed551d4a238cd586850523d6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_694fd1ceba4c', 'harsh.iyer560@example.in', 'Harsh Iyer', '+918847047402', '8105-9543-6818', 'SGRPO6455M', '726, FC Road, Sector 45', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-10T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_694fd1ceba4c', 'bd983869eee2cb883de2460bb5f4e010cc9592ec6bd5722ebe174fee0309bb16', 'f01d0df83389f41ed279917cfa2cd285', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1a513a0d418a', 'pooja.kumar561@example.in', 'Pooja Kumar', '+917583006033', '9330-2072-8996', 'LGGPE7322W', '885, Connaught Place, Sector 43', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-05T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1a513a0d418a', 'e4d3849e94639a61282bc922b96950b55f08e8f9ae447c896a3e5d01293e7c1d', 'c0969d3c83bb532d1e623f3b210456b7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_40d2ce3a3386', 'abhishek.singh562@example.in', 'Abhishek Singh', '+918569567073', '5360-1116-4424', 'XRLPY8393H', '867, Koramangala, Sector 45', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_40d2ce3a3386', '09f413b7647f7fc408bdf1cdb5eac885f8d4593836b88fca2949192d6c9e9a82', '5b1012d176e48f7b063993e6a257829a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_816db1d5b927', 'swati.dubey563@example.in', 'Swati Dubey', '+918978913801', '6358-7530-8421', 'POCPJ7518J', '945, M.G. Road, Sector 13', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-09T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_816db1d5b927', '0ebb73a95da2c13bb54f301bb8080d21c39fc51140c22ebff8b690ebb7798918', '1ec8e365dfaec8f1245589830dce6d7e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1bba380be6d0', 'vikram.bhatia564@example.in', 'Vikram Bhatia', '+919574154808', '8545-9437-2720', 'KXTPR8930J', '372, Anna Salai, Sector 16', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-17T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1bba380be6d0', '4bf277aba9f0628e782d2670664869e261f518c5e6dfb61536fd90cc04e240d2', '9f582f74e4b923f406ed5293bf226012', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f487ef97336e', 'isha.kumar565@example.in', 'Isha Kumar', '+918217303884', '2907-5551-4901', 'HVIPT8623N', '248, Anna Salai, Sector 21', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-29T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f487ef97336e', '2ab1269be3a839ccee800837427fcbb4f486c3d82692c45a3b5a55cddf27d45a', 'c96ee0fc0b5765c0b319140b5b39d69e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_574d535449b4', 'anjali.mehta566@example.in', 'Anjali Mehta', '+918436101641', '2448-6162-8157', 'UWGPK3811P', '141, Sector 17, Sector 31', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-10T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_574d535449b4', 'd0c6449539c96bee919ee9aea6e20690f3089cac3d9b43600d001f735c919a0d', '67515e22a5237200613dc35dff63d996', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_04f3f0cbbd8a', 'harsh.bhatia567@example.in', 'Harsh Bhatia', '+918869627130', '7281-7028-7378', 'KDPPU3254M', '474, Brigade Road, Sector 13', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_04f3f0cbbd8a', 'd4549eab58860796cdfc368e94799f677f352e82039ea327f1198e9973db08e9', '330eef6d725b726d7d38f00913456283', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_49e2f7344a9d', 'divya.chatterjee568@example.in', 'Divya Chatterjee', '+918454582505', '4135-2301-6535', 'NYGPV8948X', '82, Brigade Road, Sector 8', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-08T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_49e2f7344a9d', '502b3d791a7443f3f57a18d7b367f59a3ad80871d04005cc10bd3555eb7913d9', 'a35671758e18b2a2ef6be8ab3eac6df3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1944ffb276bb', 'varun.trivedi569@example.in', 'Varun Trivedi', '+917901722159', '9874-4740-9811', 'AMKPS0676E', '74, SG Highway, Sector 40', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-11T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1944ffb276bb', '8d3a42e276f20025cf7a1e1f262a05b68010e5932eb7f35530178bec96ec07a6', 'ec1570f0dfdf44620f2be61fa50dce59', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa38e407c003', 'pallavi.rao570@example.in', 'Pallavi Rao', '+919394160042', '9318-4614-6780', 'EUGPJ1592Z', '57, FC Road, Sector 43', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-04T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa38e407c003', '2f086e92c1c93dfce14f105a1f5b98bc60238bdd753408a96ea5a6b8c740af9b', '5faaea3c0f97d6f5b5109f932f77f81e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b3c72c1c48fe', 'siddharth.saxena571@example.in', 'Siddharth Saxena', '+919856319086', '4295-1188-4226', 'TJIPM8180W', '696, Koramangala, Sector 25', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-15T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b3c72c1c48fe', 'da514598e90a1e7b2a7a02ef529bd6862c9366c03f4b3d32dc070f1fdc81d3b7', '3368206841a4cdfcf2008942512b23f6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_110c7a3198c0', 'ritika.gupta572@example.in', 'Ritika Gupta', '+918346635645', '6177-8865-2380', 'GOLPI2899C', '825, MI Road, Sector 32', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_110c7a3198c0', '63bbfc0cbd03dde5b59d0601b3189ce9b7a6bbb26f5bd3890497fdcb9e2a9ea5', 'b089d78f7973314c469e88479895101e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0f85cf92b0aa', 'kavita.mukherjee573@example.in', 'Kavita Mukherjee', '+918985368011', '3837-2237-6579', 'CPDPC1969R', '787, Sector 17, Sector 14', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-02T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0f85cf92b0aa', '416e8f46e2e37dfd4e26a7ea97b0150c992d8a28f2665ee35060160f2ca2ec1f', 'eb44a3f78328271113ebdb1ff0f33faa', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2f06a4aced0e', 'manish.kumar574@example.in', 'Manish Kumar', '+917377004532', '5121-1463-8369', 'YHDPH1275B', '892, Anna Salai, Sector 29', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-29T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2f06a4aced0e', '94ffc05e0544a6fe3a59d316fadaa4f96a228f848435c6d94ed49e4184169081', '3568c74e397a774c44d19d748ace3e1f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d49437cfb94b', 'deepika.reddy575@example.in', 'Deepika Reddy', '+917400021205', '8443-1011-6590', 'DCCPP5996L', '357, FC Road, Sector 13', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d49437cfb94b', '107937365aec326143674eb2015e204676178e9a648a35e385fba1bf77e4d5f1', '67644da0f790b4eb8a92b91a686f0dc4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d1c8077a229d', 'deepika.dubey576@example.in', 'Deepika Dubey', '+919590965789', '7646-2335-4028', 'CQXPE3218X', '724, MI Road, Sector 26', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d1c8077a229d', '435b72e2faa9b5630a97d830c56850a6e1e2567aca1d762618d0caaa77b74a5c', 'c764de9ead1e07c14dd0a8aac7d5401c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_38f6d9436489', 'varun.kumar577@example.in', 'Varun Kumar', '+919922254580', '4727-7055-7904', 'LPBPS3872K', '597, SG Highway, Sector 42', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-03T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_38f6d9436489', '06006524e3123a3c8825835f927baf2d6c7effaac93e26ef62e6db7fc3561a51', 'ee53d3ac66b15d0bca810f7606d26dbd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4e1b6e8b7a32', 'rahul.chauhan578@example.in', 'Rahul Chauhan', '+919997827706', '4630-8087-4175', 'HCXPX0517H', '670, Sector 17, Sector 23', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-27T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4e1b6e8b7a32', '1c3bd74a6df3049c6170d97efddd1cc4204577ee8fad3002e04a3fc6b3bd4f91', '052447d832d4d94233d4bccbbe311fd1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2a3dc78b48c7', 'shweta.gupta579@example.in', 'Shweta Gupta', '+917257475197', '5453-6414-6755', 'ZGVPS7432E', '55, Connaught Place, Sector 12', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2a3dc78b48c7', 'bae2da9d96cad140c79993fe7551d53cd7a7092f66984858b79ddf84af3321c6', '3c61b761fa7ec0182f84670e85c01622', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_38ac37a647dd', 'divya.saxena580@example.in', 'Divya Saxena', '+918476601202', '8623-2274-6065', 'ALEPG0850S', '569, M.G. Road, Sector 1', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_38ac37a647dd', '60bd48a084951f8accd838dfec486091e4ae58d77be66fb7f3af5d0001a81e09', '0b42652dc4b6e310d2d862b361f4114c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a5caca49c284', 'sunita.trivedi581@example.in', 'Sunita Trivedi', '+917509757275', '2649-6784-2697', 'EXHPC3176Y', '132, SG Highway, Sector 1', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-11T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a5caca49c284', '6672caf195aaa083f515b05740abb4d76f368c8c29122921de9e79f4c26fde8d', '5c1b897e42947373784c839f1b412c2b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9170f56690cd', 'dev.deshmukh582@example.in', 'Dev Deshmukh', '+917561795584', '3387-6324-7475', 'EEYPR4620Y', '369, M.G. Road, Sector 37', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9170f56690cd', 'f0379b5ab2d6bdd1ffcaac4ce1fad7e8e66a00e21ffb9fd85a31284f72fe5a0a', '2c7e5d2b61e477e2528f32a074f159c6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9543ab803223', 'dev.singh583@example.in', 'Dev Singh', '+917220871847', '9924-3618-1548', 'OUOPX7139W', '368, MI Road, Sector 34', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-05T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9543ab803223', 'c6c56cda65c8b2c31b2a62b92b8edd25e9472cf2ca4dc23812c0bd2a58448854', '31498c196111609011c4e6d7ee024153', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df86ae8a0c18', 'kavita.patel584@example.in', 'Kavita Patel', '+919416812839', '2063-2874-2725', 'BLGPL2099E', '525, Indiranagar, Sector 36', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-30T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df86ae8a0c18', 'da3140813b9736d73a2f2475b5a5f7ac52fd1ba32c532a32cec30fba86ce057a', 'c2ef5e75adcb10ba1f0190107c048f7a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_23941805f0cc', 'swati.nair585@example.in', 'Swati Nair', '+919694260481', '5512-8556-2849', 'ZVZPU9537N', '292, Anna Salai, Sector 7', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_23941805f0cc', 'a670f117e03981ba1f864d884ae1671d35d24c2f9e731563924b156e8b3b6dcc', 'e9f114ef0d332b6b76c3c993a83ff20b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6a0557756835', 'pooja.bhatia586@example.in', 'Pooja Bhatia', '+919147794578', '3911-4799-9424', 'EERPU6247H', '623, SG Highway, Sector 41', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-30T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6a0557756835', 'e8ac6cc91311303246b7273456af9e1c06178cc095dd77bc493eda509b361324', '2fe939fd46c8b4c0084c19b261a5a533', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6c51206848fe', 'kavita.pandey587@example.in', 'Kavita Pandey', '+919126402848', '6569-9908-5535', 'MWLPW4030V', '807, Park Street, Sector 18', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-14T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6c51206848fe', '5fb9740d1914afadcc0eee5721b52db3412a6d00df3609b5ab76d12de8290ec8', 'c85a548a23ebd9b03d4e1a37da2e63fb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_44c3802e7126', 'divya.chopra588@example.in', 'Divya Chopra', '+919211077211', '7291-5440-2646', 'BBNPF4088Y', '829, SG Highway, Sector 1', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-16T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_44c3802e7126', 'a7ff2efbd252001adc042405384c5663b9fcb922c48cec9eb2a79f6c70919f87', 'a100993b1906061c68fa30843e01d467', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5f4ae4aba747', 'aarav.kapoor589@example.in', 'Aarav Kapoor', '+917809636804', '6656-8687-9739', 'PNEPM0778R', '239, Anna Salai, Sector 12', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5f4ae4aba747', '8e2ce7992d4d2a8a76e35e4c407d212d16b29d42e96de1e32f2b52c12e4c506a', '51ade44cf15befac360157e8cff75574', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5bc9ac1eae30', 'sanjay.mehta590@example.in', 'Sanjay Mehta', '+919376332097', '6763-9886-9645', 'EWQPN2161K', '667, Connaught Place, Sector 44', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5bc9ac1eae30', 'efc020bd15f63dc44142813cd48eaaa3fcb017d870c84cc1c8e504447cff55de', '10aa0f5f06c45f7a47fe56a4d99e655f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_95f898758a65', 'vikram.agarwal591@example.in', 'Vikram Agarwal', '+918557963318', '7592-6871-6602', 'KCMPX3286F', '942, Park Street, Sector 10', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-15T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_95f898758a65', 'e3caec43343c310b69222fed431f7f6fcc6e0bf29b1861bd56042203e54db247', '502516fde990b0a65142b0df5d64f6ff', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a95966f870f4', 'abhishek.gupta592@example.in', 'Abhishek Gupta', '+918666510203', '3016-5306-5095', 'XGKPO0392U', '774, Anna Salai, Sector 40', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-22T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a95966f870f4', 'b9592cefe70a93ec133767aa6037d5ab43357e18fc6f56ea13dadbc999b9bb46', '71e25a1645dfe2631a2b91302dc0a8c4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f685241b1c74', 'pallavi.malhotra593@example.in', 'Pallavi Malhotra', '+919557875934', '7500-8015-2479', 'DIEPW0567M', '630, Koramangala, Sector 9', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-09T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f685241b1c74', '1d46afffbdcac2fe975280769f37ff581ad5235422cb7e1ee5c6ec1abd43d58f', 'ffc4a8b8cd47604edc94c4ab7662a1d3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aacd6959db2a', 'rahul.chopra594@example.in', 'Rahul Chopra', '+917170853351', '6612-2147-4398', 'AYMPH9892O', '949, Koramangala, Sector 7', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-22T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aacd6959db2a', '44ab9a8f70ceff4dd210b0f4dcbdd6d801ff523360caf142aea9580c6aa04a1b', '66975ab59f7d01f2820125f93fb0ca86', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_114bf05a80af', 'isha.mehta595@example.in', 'Isha Mehta', '+919725914190', '8684-1462-2733', 'XENPM9010H', '266, Indiranagar, Sector 35', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-03T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_114bf05a80af', '72b96d2903fa470eb4f5f245d3ea01db7a025ab9cf4017df6a46343e954f55ae', 'a0c6db131e501ed6b30196733478c3fe', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_56c66a0fe4a7', 'nikhil.menon596@example.in', 'Nikhil Menon', '+919698164903', '4907-3411-9672', 'UVEPC3046Z', '81, Indiranagar, Sector 2', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-13T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_56c66a0fe4a7', '51fa84b1ef5cd4dc059933f1a751c26ee4a4eac5736a89acc7f95ddc1e58470a', '7aaeb6d1e6437acdc2b460d1175409dc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_42925fc7a57b', 'priya.gupta597@example.in', 'Priya Gupta', '+919259744085', '2463-5621-4941', 'KVGPP8341E', '975, Sector 17, Sector 32', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-31T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_42925fc7a57b', '7692fdd457478189ed81547af5f23ce085c25f1cf587a453ccc0c6c4d0b2ca47', '01d68cf5db1f4622cdcbe9d9610da7a5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8ce90f8b4adf', 'divya.sharma598@example.in', 'Divya Sharma', '+919184372386', '7794-2587-9131', 'BGJPG6245O', '872, SG Highway, Sector 6', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-13T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8ce90f8b4adf', '33591c6216163b1b5c3c5ca974e6f1a1e7e4997b6472a415eb610e029751f83b', '2aef432ecc86234f78b022a6cca98fdb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a184e441844c', 'manish.kumar599@example.in', 'Manish Kumar', '+919230776752', '2363-2749-7919', 'RIZPH9141M', '713, Sector 17, Sector 41', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-27T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a184e441844c', '7413226275797d224b2faab9a59a68296a2105d78128fd49a9151cc3d08fff70', '9d8c360374141efe0c82bda8dbfaa4ad', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5b441aba6254', 'aditya.pandey600@example.in', 'Aditya Pandey', '+917532881784', '9916-6796-4758', 'KKOPK5747P', '272, SG Highway, Sector 44', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-20T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5b441aba6254', '9447a4410ab5eff4d44b9457aefc2ab8fc3a9896e02a5a6981388e56ce672ccb', '0374f88e64139809967223148c52df30', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_be4b3d0fc564', 'swati.kumar601@example.in', 'Swati Kumar', '+919872145873', '3142-4678-5474', 'HUYPF7027G', '235, Koramangala, Sector 45', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-27T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_be4b3d0fc564', '21261e172d2f372ea9c272fe8813283f74f9fed19200c56066b2e6e3584f8f1e', '493e1e8555c985503dc06630646f1e5a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bb87cec4c301', 'neha.mishra602@example.in', 'Neha Mishra', '+918180242387', '6207-4507-9460', 'CYOPG0052T', '180, Koramangala, Sector 44', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-09T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bb87cec4c301', '862e7faa6c0cc4ac98880f8b221d31f9961e9fe413422ce169c8837b0d61f7c5', '104b15177412b085890943da3b44d8f4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0a3dbb92eaae', 'shweta.verma603@example.in', 'Shweta Verma', '+919158345551', '7357-2740-6999', 'TMMPP3612B', '699, M.G. Road, Sector 26', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-18T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0a3dbb92eaae', '82f17405410918d5490377f79d1c651b8fdb94305db1afdd0d3c7f347a67e465', '0e6729040d483a937ec5b9afa5653824', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e29295f5c04e', 'aarav.iyer604@example.in', 'Aarav Iyer', '+918747679020', '2685-9834-6879', 'VLXPO7942G', '634, MI Road, Sector 38', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e29295f5c04e', 'e8047ed3f7cebb735c56c45e3762df2630a83985b97046d5b83e41cf26867823', '9287a24ee6a60f6fe56e4f0b71f21a60', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1032a7a73988', 'rajesh.joshi605@example.in', 'Rajesh Joshi', '+919666214152', '2665-4262-6777', 'FXRPE2627D', '330, MI Road, Sector 43', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-24T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1032a7a73988', 'fb3f85ff8110eda0d262ffd1789b3c7d889d93a51d4623d04b888ab1eef5d1c8', 'b30e9da8a51d72a6104d36240851eac8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_69388ebc5567', 'anjali.nair606@example.in', 'Anjali Nair', '+917372562774', '2815-7258-7046', 'OYAPV1098Q', '4, Koramangala, Sector 23', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-31T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_69388ebc5567', 'aa1a598b04a645d1877c1a5c8a72282a4017f9ac4ff789a2aa3ec5d534938caa', '37ecd2e6c7bee2785f9b688e35b139ba', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_189da06aaa83', 'ritu.rao607@example.in', 'Ritu Rao', '+918905795812', '5135-4185-4247', 'IVXPY4339G', '114, Connaught Place, Sector 14', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-14T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_189da06aaa83', '10c6b52182ffe0f049ce99b9a1b914311e5751f686ca07791b4b1b7b243ca452', '4457ebde6d9a91873d44241f0ecdb08c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa74d29c650e', 'manish.joshi608@example.in', 'Manish Joshi', '+919901182946', '2931-2307-5686', 'QYAPA9750X', '927, Sector 17, Sector 38', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-16T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa74d29c650e', 'd1c46b220ca8dd2efebf63190b39557af1a5e9cbc263d5cc927f67f550a2180e', '7ee94f6a8525f44de61c53a2194dbb13', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a6ba8be85b4c', 'divya.chatterjee609@example.in', 'Divya Chatterjee', '+917436642288', '7458-3051-7027', 'MUDPP0599D', '537, Banjara Hills, Sector 39', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a6ba8be85b4c', '91ae4cc1edbc0b4dd8240896af4e02ba5ea17f50ede17541f4dafc62dc46b3de', 'da515a86946cc8aeaf90d2aa5d305cbd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_83b62eab2a3c', 'neha.nair610@example.in', 'Neha Nair', '+918766039435', '5605-2680-4871', 'IVVPM0311R', '717, Connaught Place, Sector 39', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-28T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_83b62eab2a3c', '222f0cae87357e7b3cfbf150a838a3f5a946794ecbf1b02bb9788ad34bf13c50', '60c5201be2f18b072bff1478a5a9587d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9af44d650e45', 'divya.singh611@example.in', 'Divya Singh', '+917900526481', '9097-9788-9567', 'IFYPF5719U', '172, Connaught Place, Sector 29', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9af44d650e45', 'a5829c6d7ca1c1a1092a0756f76f6f7aa21278df3cfff6121620199b0a35f19a', '1e4231524c1ce0ae3fbd5886d3ec17c0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dfd754c05b12', 'neha.pillai612@example.in', 'Neha Pillai', '+917165168298', '3900-3677-7335', 'KRXPY9777K', '945, Indiranagar, Sector 19', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-23T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dfd754c05b12', '6ecb01cf4e075d834a9135a92dd28b7356e8176c9e42fad33f4125c34da18aff', 'e58c1120f951bd325c3c6014a2ac34fe', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5b19ef89870d', 'sunita.nair613@example.in', 'Sunita Nair', '+918952494726', '7454-4038-6321', 'GJSPP7752Y', '161, MI Road, Sector 3', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-16T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5b19ef89870d', '5ddf897d0179d4bfedb649b32ed54c0d5b0f5534830765c7b8407a32e6c63def', '8a7c066371f5a23021fcbb1ede0e8d8b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1876db82052c', 'amit.kumar614@example.in', 'Amit Kumar', '+919949060989', '4620-1116-4562', 'LLYPP4569D', '448, M.G. Road, Sector 3', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1876db82052c', '56784bb69365664648038ff5ad2e8bef0e5de286a4ebaaa65172f794ae0d0d5c', 'ccb375c4094646c08eeddb42c81e7859', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_184d9962b8ff', 'gaurav.gupta615@example.in', 'Gaurav Gupta', '+918375613404', '4214-5084-9952', 'RXBPW0872R', '298, Anna Salai, Sector 32', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-24T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_184d9962b8ff', '74bf4790494fbc9346ab9483b63ba198a1353daf8e6d14eb6ad8ddf7a676292a', '54e75739d7989ad8cda7358e8f3a4579', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_855b01740a67', 'nikhil.iyer616@example.in', 'Nikhil Iyer', '+919436598093', '2059-1453-7149', 'YXOPA9543H', '587, Park Street, Sector 24', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-20T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_855b01740a67', '808909180080eb477659dce27f5ce16fe39e33ed41df6ca261247ac5f9af6650', '8af675f3d4bc651c9d92dc2d3a521114', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b6fea26e4be2', 'rahul.mehta617@example.in', 'Rahul Mehta', '+917357437699', '8775-3484-8754', 'GREPZ8280V', '850, Park Street, Sector 21', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b6fea26e4be2', 'acfac03b2011e8f2bcf71c176cd4dfd45200ba456068bd6691276de2439b755e', '1a40b0e3522f512761d2e2a9ac03c436', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_908f9f5253e3', 'sneha.mehta618@example.in', 'Sneha Mehta', '+919979537372', '7845-3703-2809', 'MIOPF2985Y', '82, Indiranagar, Sector 14', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-25T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_908f9f5253e3', '046d5b7525b5dc3f73fa871b82acdbbfde643c76d3a5c027a7a4154a36fabef2', '33fe616c2e690d8ad912452031f2d45b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dd68c1858cbc', 'arjun.singh619@example.in', 'Arjun Singh', '+917388600535', '4152-1636-9633', 'CJJPU9552N', '662, SG Highway, Sector 25', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-03T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dd68c1858cbc', '28a11a4396568096bf760ba44959462680122593d1702384c58f72ccdc8acaed', 'c67232be3ce8fa3e6adc57c866941403', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a30c427c2d3f', 'simran.chopra620@example.in', 'Simran Chopra', '+919152686151', '2216-7144-1286', 'PPHPQ9894W', '387, Indiranagar, Sector 43', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-19T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a30c427c2d3f', '245302fdd591b84a8e2046f55a8c0ddaff423a9327cb67aa1bc910194a634c2d', '5b4f28144e3de457009d1a652edf5879', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0898d490138e', 'anjali.saxena621@example.in', 'Anjali Saxena', '+919878386026', '6428-9075-9471', 'WYLPI8762Q', '301, Koramangala, Sector 15', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-05T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0898d490138e', 'e94d46757a95cb5e9824da9f91b2ee1170e4de56af60a0a8abfaf9e20144d004', 'f9a22bb74f7d23cb51d15975a63e1654', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_37bafac13d09', 'simran.deshmukh622@example.in', 'Simran Deshmukh', '+919305759957', '2810-1173-4566', 'JVDPD2913B', '327, Indiranagar, Sector 25', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-10T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_37bafac13d09', '352f7acf0197cce4349235acbfff63b535b913cfddc80df601ee925b69925dbc', 'a30ba905f0c7e74846a0aab7dd3aed82', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e214e2c95b8d', 'sanjay.rao623@example.in', 'Sanjay Rao', '+919978205850', '3715-6961-8137', 'JZWPQ8352J', '903, Anna Salai, Sector 36', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-20T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e214e2c95b8d', '40a3a885343048688fa1a9da9feb9d7cce7bf28d5a95cf203564465a458a8250', '645cb74d7a8157dc557c472ebcc78f80', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f255dec8c204', 'ritika.bhattacharya624@example.in', 'Ritika Bhattacharya', '+919102478918', '7259-9064-5858', 'VBQPU6223K', '946, Sector 17, Sector 36', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-22T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f255dec8c204', 'cd6c82610623c7737d67a796955521ff690777d2d19efff25edd7f5a17f0b1cc', 'b3829625230a97189ab08a067b2203ce', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dd7cee5ac09d', 'bhavna.saxena625@example.in', 'Bhavna Saxena', '+917798544147', '9386-4218-9861', 'KBXPE5316F', '702, Brigade Road, Sector 35', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-08T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dd7cee5ac09d', '797cb9755dd9e1efec003c4d68a32edb548d31882954f5c50e9fc80500c53a42', 'dde452558f6aa214fb429ed2a9a43c01', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_627d29dbcdae', 'sunita.trivedi626@example.in', 'Sunita Trivedi', '+918110098897', '5654-1138-5072', 'XDVPS1430F', '775, Koramangala, Sector 28', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-10T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_627d29dbcdae', 'b9992ecf01a5f0b36454703cc08f4846fe7715da23eb2c30cac4df0599ff4d46', '2b058b60dada075a6ebedf802f75080d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bb11a75d42a5', 'ritu.kulkarni627@example.in', 'Ritu Kulkarni', '+917714282045', '4563-3383-4618', 'BNDPZ8441L', '729, Indiranagar, Sector 40', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-11T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bb11a75d42a5', '0d15552fe8bb74793962153d4c0ea677072958e8ff14b1cbfb6f977c4ed96f4c', '53f781cbf6eb02b807e8b997a1ff515a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7c1be2fe6b3a', 'sunita.mukherjee628@example.in', 'Sunita Mukherjee', '+919741985998', '8477-5498-6487', 'WVBPP5906E', '717, M.G. Road, Sector 31', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-05T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7c1be2fe6b3a', 'd2be955f99e763b7f6543e36386564dc35da29d933b1ddae26f4c632707f7939', '8fd7eabc247163700f11eb65f6ffa845', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8fd64af25a6f', 'manish.trivedi629@example.in', 'Manish Trivedi', '+919163737125', '5584-8002-3757', 'ZVIPP5508X', '159, Koramangala, Sector 43', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-23T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8fd64af25a6f', '9ea473eb9201b38e8f0b75e9e5d75de320982aebe920f9a031124b91b5eab4dc', '2861252515f4635c74f19da2b7e33af7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f992e031892e', 'abhishek.patel630@example.in', 'Abhishek Patel', '+919177124216', '7236-3688-2298', 'SZBPI8262A', '682, Indiranagar, Sector 28', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-01T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f992e031892e', 'cd78e1128f98dc15623b216f3291ac3ffab43b81cbafa71cf22ed4f5f3e5f062', '7a16302246ea67812edf9bb30b1b2eb3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_db4a075026b5', 'swati.deshmukh631@example.in', 'Swati Deshmukh', '+917577656125', '2899-5855-5376', 'XDXPL2651Z', '547, Banjara Hills, Sector 34', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_db4a075026b5', '3ac730ea1a99198f7e6e6f5f22210acc82f2d56333f082787abc931b65a993b9', '1c9abcbcfb2d66099527cbf0dcb98719', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_21002b742a20', 'ritika.dubey632@example.in', 'Ritika Dubey', '+919285674217', '8741-6469-7809', 'MIUPY2812I', '105, Park Street, Sector 26', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_21002b742a20', '3d0790de91b882f43cbd4f7e7dfd9425baa830fd8a8e286db658e2889ab899ca', '593dd87f42db5f5914f7401977e2a695', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d0512e8a93bc', 'neha.trivedi633@example.in', 'Neha Trivedi', '+917157121494', '3796-7262-5226', 'UBGPY9190E', '987, Indiranagar, Sector 41', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-25T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d0512e8a93bc', '13e2c1e5b5c8692167fa63183916b58bb0c648eb6ef1aea1b5a4396f45ce5d7c', '21d98d5eb87010ba0bab93d8b16bd5b0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ddf2657fd9e7', 'rahul.bhatia634@example.in', 'Rahul Bhatia', '+918906440378', '3869-8066-4263', 'KLNPC9683M', '26, Park Street, Sector 27', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-12T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ddf2657fd9e7', 'e8447fa1ad659bea9bb856c7bdcc2b2e027298f9482596d3388508b20c43ec59', '53a13f5b3c59ac9ceb9d5e1f557f75b7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_816bcb53c6f9', 'karan.singh635@example.in', 'Karan Singh', '+918845483390', '6336-3774-6861', 'MMBPF9738L', '579, Banjara Hills, Sector 40', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-29T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_816bcb53c6f9', '92ae5751ce2984b2236cb5c1a16a2cbc8528518b01b7445ea4a0f224e752b9c5', '7f575e62a9219860febae3bd87e9becb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a52264ada601', 'rahul.dubey636@example.in', 'Rahul Dubey', '+917239489739', '9021-8429-9916', 'RXAPU3918R', '808, Park Street, Sector 25', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-07T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a52264ada601', '571702e27b280ab90fd351a2aa1ffb14e3c9250da5cf085efd7af913bb75a6c5', 'c8d6a1e4d0688a908a5f1f56bc677d9c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d14d10c04a05', 'anjali.mehta637@example.in', 'Anjali Mehta', '+917238350723', '5001-5850-1087', 'RKWPS7766Q', '34, Indiranagar, Sector 20', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-05T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d14d10c04a05', 'e03fa18d89e753d77fe170027a8fab64f0140bb27a8a7f77353d77c2d65b9824', 'beaf4c13cb6e666f8f8d3b99ddcf2767', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b7a09e154a22', 'siddharth.nair638@example.in', 'Siddharth Nair', '+918533277547', '8624-6935-3765', 'XZGPW5911P', '204, Sector 17, Sector 34', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-29T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b7a09e154a22', 'aafff53f92721ce70674424f25a0bb8cd6eb9e43a6f5b8eee1e568b2b9b64d4a', 'baa890f06d24b1d4c534758c2e641609', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4123f9ad2626', 'pooja.bhatia639@example.in', 'Pooja Bhatia', '+919398352720', '9063-6096-6554', 'EYCPJ0690C', '855, Connaught Place, Sector 32', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-04T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4123f9ad2626', '655469de9609d2951d75b0d0b46a8f7fc9d1640ecd0bae71329613e9ca58a25a', '19f471cc90220c048d589321be3d2dc3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_35dc72efbf39', 'dev.gupta640@example.in', 'Dev Gupta', '+917402246489', '7751-5768-9251', 'KXTPA7505E', '140, M.G. Road, Sector 7', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-14T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_35dc72efbf39', '8b8ea344558f32e6c2146de714e98abd05f34491037d03fff78f73f492c626c7', '8191cfeb041527299056c498357e8663', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_732b638ddae7', 'swati.rao641@example.in', 'Swati Rao', '+917870743732', '6713-8276-5813', 'XOEPS9083V', '793, Sector 17, Sector 32', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_732b638ddae7', 'd28b7e2a3fc365eb7f3f00d9d37fba18f735601482dcaf446e91bc820f1cdbae', 'b4fddcf19157ba0d89136eea91306810', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9d45a9b6a4ca', 'pallavi.gupta642@example.in', 'Pallavi Gupta', '+918715270863', '9638-9553-5258', 'XWUPQ6510C', '956, Sector 17, Sector 40', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-08T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9d45a9b6a4ca', '43bbcae77975960738b39c8434f8a85afe8570c1a3995c816991795fbb95026d', '6fa81bf758a7350a6c38394d26ba5034', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_66407670e204', 'nikhil.bose643@example.in', 'Nikhil Bose', '+918655334439', '8269-9109-9755', 'BRZPJ2971Q', '958, Indiranagar, Sector 26', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-11T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_66407670e204', '17cd2617ea751aa041888c17e518786603372c514c8372124ae463605e640d92', 'd21aff7a2ee6a6a156d4e4a304664dc7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b639a9226ff5', 'aarav.malhotra644@example.in', 'Aarav Malhotra', '+919698548704', '2860-8864-4791', 'TDSPG6951X', '419, Koramangala, Sector 11', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-17T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b639a9226ff5', '203166665987d9dc7495f2688eae375be2503ad395f45989a08335da563151b3', 'c94bd325f6aef0ae1372bab070a22223', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b05267900f98', 'pallavi.agarwal645@example.in', 'Pallavi Agarwal', '+918914055047', '3454-2930-8982', 'RLRPP6218D', '618, SG Highway, Sector 8', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b05267900f98', '56b90b327809a42bafc01e35615d65a3dadc5f59a040a4b352fc82201a6110c0', 'b09596490d1b233351359221ac210276', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_987ec9547636', 'manish.mehta646@example.in', 'Manish Mehta', '+918607568939', '8328-2922-7324', 'CZRPL6527O', '676, SG Highway, Sector 16', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-17T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_987ec9547636', 'c6edc3f38217cc28e8f4efd9aa90a2a5938cf353b707a62fd586162753da4a6b', '321ab9e0cd39810958c166ddf30fa734', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e368c337c31a', 'shweta.mehta647@example.in', 'Shweta Mehta', '+917794323488', '8996-8862-6530', 'YCKPQ8719A', '126, Banjara Hills, Sector 43', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-10T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e368c337c31a', '96c16b72fa73827d335ab4d2c5938567bb0c8fd612b0a0530841bd547553664d', '242f4a022b38547affa164e3592b0f1b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_71072e983fcd', 'deepika.kulkarni648@example.in', 'Deepika Kulkarni', '+919658706911', '5155-4939-5463', 'WVLPH0993M', '865, M.G. Road, Sector 17', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_71072e983fcd', '5cb03b7282f2176c1e04afc7c55b5a763cb2d983456aae8c3d895aa058a562a3', '00abba4c7416eb68c69973735de12751', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_49993afa555d', 'kunal.kulkarni649@example.in', 'Kunal Kulkarni', '+918897251132', '7241-5507-8891', 'VVNPU3770U', '180, Connaught Place, Sector 17', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-04T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_49993afa555d', 'ba9c3e69fb0d7acae66032c7a30dbf268ed8e1767db011781dda35f545a29088', '9799584ee9dac763b580623f3bb74434', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_17d163596783', 'tanvi.joshi650@example.in', 'Tanvi Joshi', '+917490959345', '3082-5634-2029', 'UWMPF9621D', '463, Banjara Hills, Sector 2', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-12T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_17d163596783', '560dd01e052df891e05623f03803f824ab23cb227497da68df2a79ff62f7e47b', '07a5b3b55b8179dcf37a34542b1f3753', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4a20da0ea292', 'isha.verma651@example.in', 'Isha Verma', '+918867788210', '3651-6521-2586', 'RSHPQ2549B', '5, M.G. Road, Sector 30', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4a20da0ea292', '0c9625debda885fe2cb2b1bd19f634e21c3650eca9aa2634e07eacf9cb232db8', '493445aff2e5c2460864ff35510a5596', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1585e88d6f56', 'swati.bhattacharya652@example.in', 'Swati Bhattacharya', '+918235989385', '5439-8019-1877', 'FOPPN3743N', '583, FC Road, Sector 19', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-05T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1585e88d6f56', '0ae4d5893615b0d06c7d6e8daf08965b728dc444e5a1a6666acba2b8f1cf2365', 'dbbe58c945f6a4a30494b23dd990c618', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c6e0841c93f3', 'ritika.nair653@example.in', 'Ritika Nair', '+919225382425', '6312-9751-9980', 'LNSPE9928Z', '764, Banjara Hills, Sector 11', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-17T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c6e0841c93f3', '4cae1cbcd5276aa90c3bce85a8db936334dcfa883bc1786df40ffc2b15fb2a8a', '622633bae5c23b258e7a0b9414876e24', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_639981fee91c', 'varun.pandey654@example.in', 'Varun Pandey', '+918334068341', '2920-3319-8761', 'ALGPE6725J', '370, Brigade Road, Sector 35', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-29T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_639981fee91c', '3a4eb32672a3dc6137e25ed4760a9ee8f86a2027663564a5be9375e24193c2ab', '859575f1c035668774a3e42ef9290ce5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9e09895f83ff', 'swati.trivedi655@example.in', 'Swati Trivedi', '+917771755418', '2710-5599-2389', 'NPOPL6913U', '993, Koramangala, Sector 24', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-16T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9e09895f83ff', '78e82f443206ca761fc56fce58c025dccc175c8ab10785c4bcc1335bf96a4036', 'dbeccef94324f76f429f8264166f624d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ba9f1023f813', 'abhishek.gupta656@example.in', 'Abhishek Gupta', '+917344214192', '3923-9141-3178', 'WCHPL9012L', '606, Park Street, Sector 18', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-03T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ba9f1023f813', '048f3cde550e45781ffdbe77f7c637f86832481edd771ff373eea6c79f3c68e0', '1943ff64c540d82714e071ff2e40a3e2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dd29b2ce936e', 'siddharth.agarwal657@example.in', 'Siddharth Agarwal', '+918889455231', '8479-3290-9930', 'QEQPM4498A', '720, Koramangala, Sector 11', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-04T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dd29b2ce936e', '64bd7372cbd733f96a22972c5a9a9a64deaa6d64726ee2c75035e5fd736b10af', '7e02d2c8eefd8e3f4bd2269d10bfa8f8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9e7dd69b6055', 'sanjay.mehta658@example.in', 'Sanjay Mehta', '+917169018106', '5000-3078-6917', 'IRLPD2354K', '15, FC Road, Sector 27', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-02T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9e7dd69b6055', '987a4485318a5cd480e8705086bcd076f4f5906956d1633d7eef4d902ba41008', '66c95f015a2c77bd52520d6686d5d6aa', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1997ec61cbed', 'gaurav.bose659@example.in', 'Gaurav Bose', '+919482878689', '2445-3737-4643', 'IJKPO8036W', '130, Anna Salai, Sector 17', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1997ec61cbed', 'aa5166d3ac7cf50b1ec54f336edec78b3f9831809851892892f28b517f7b351e', '8a1fb6791821a711a249c9580bb709c1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a8508a1b971c', 'ritika.deshmukh660@example.in', 'Ritika Deshmukh', '+918775404577', '2551-4899-7986', 'VWZPZ0671W', '831, Brigade Road, Sector 42', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-11T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a8508a1b971c', '2b8cae92d6339d311a19675912c3b62250d5b9710538e012a1e882e5842a2890', '3801633e6b842bfe1a7de7c68e692fbd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d223dd316fc6', 'sanjay.rao661@example.in', 'Sanjay Rao', '+917335368087', '7254-6561-8362', 'VSZPY5162J', '437, Connaught Place, Sector 11', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-07T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d223dd316fc6', 'dd7dc9525c354da583d0f25cbb2a8b0ab4acf15c4b597c391fef2d90cbcae37e', 'a66979885c29aaf5731b58afb886914b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1b8bb8333c79', 'arjun.dubey662@example.in', 'Arjun Dubey', '+918647780788', '5611-1997-1017', 'CPIPG9189S', '406, MI Road, Sector 18', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-30T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1b8bb8333c79', '8c8902b5d8747556008676a44e2a73df4d8ae93891969d1f287a7fc25d938da2', '2961620fdd3c25b3b7365c43bcc12b66', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c15f7db7b0f1', 'sneha.mehta663@example.in', 'Sneha Mehta', '+917109767362', '3024-5842-9654', 'GVOPI6986Q', '588, SG Highway, Sector 30', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-31T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c15f7db7b0f1', 'd739d2361d1c1f21dfd8e2293ee9e048b94323527110f37b8929943cd76485bc', '5e250766152477b50844059f34ebf305', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c4fc990fdc82', 'neha.chauhan664@example.in', 'Neha Chauhan', '+918108346650', '3744-7551-7645', 'MDZPA8157R', '771, Connaught Place, Sector 9', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-20T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c4fc990fdc82', '15488013f4611b6f980d18aed012327adc65520dbf865b1338d7e9211ebf1482', 'bb2fbcbc122913ff889090d2cd2ddcc6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1b7fb791b2f7', 'shweta.agarwal665@example.in', 'Shweta Agarwal', '+919991062197', '8918-5017-9740', 'NQDPR1783C', '886, Banjara Hills, Sector 23', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1b7fb791b2f7', '01628d54fae1f9cf31c6e4ecf96d9e8e8d7da772510b1ab8869efa1df533f3d7', 'e35ec25374d3820876fb6c3fc429754a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_263a93db6d18', 'sunita.chauhan666@example.in', 'Sunita Chauhan', '+919450707757', '6860-8359-5406', 'WUCPV8418T', '194, SG Highway, Sector 6', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-10T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_263a93db6d18', '2fd5b943e5598303ac142d721b7090cb11316f9ab8e0edd2fffc23c4f7447798', '6099853d0cdd1529b10e91839fd9024e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7297fb9b4202', 'priya.reddy667@example.in', 'Priya Reddy', '+918668106229', '6228-9808-3326', 'WWCPZ7690A', '832, Park Street, Sector 31', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7297fb9b4202', 'f5b7da51aa92ed8f365515620bdac30210684ec3b3679c6041f6303ed44e1e12', '740aee34233926f93c9788c5f71c6cdd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9db600d03a59', 'rajesh.kumar668@example.in', 'Rajesh Kumar', '+917997089480', '8084-9398-1042', 'YXSPJ9192O', '944, Connaught Place, Sector 21', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-19T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9db600d03a59', 'cd8e3d5d61b37fdd5bdaff91b873ece889752278b482443f721d4397c7c4759d', '5bc56aa3e14796008a955b8ddef987ce', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a174ae7924c9', 'anjali.chauhan669@example.in', 'Anjali Chauhan', '+918761685597', '4488-6940-5855', 'ZVNPX6734A', '737, Sector 17, Sector 38', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-08T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a174ae7924c9', 'fa757ad3e88b977db7deb43ba0a15ca26064ee1d7dc92d200214111002e6ca43', 'd67fc29e41f38e1c0de070f5333ef290', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0054f47832d6', 'varun.iyer670@example.in', 'Varun Iyer', '+918863397081', '7870-3694-9877', 'QBQPU9933P', '913, Banjara Hills, Sector 28', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-02T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0054f47832d6', 'ad88da29290c9ab84430a94a6090590d14a6d9a4d9288a3df1ee2165d436658c', '79fc67356bbf0df6888b8c586b3b6239', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b7e09d3eb7e8', 'pallavi.reddy671@example.in', 'Pallavi Reddy', '+917512660472', '4863-6541-8514', 'AJTPH3886G', '903, Connaught Place, Sector 15', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b7e09d3eb7e8', '92007d28c2f4d653f4324772d0b5cd7731b4f2f047e0ac12170a3cc1fdbde9c9', 'defabadc5bc189bd950fd3478af50652', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f3f95ee2a74f', 'pooja.patel672@example.in', 'Pooja Patel', '+917153213756', '9730-1441-6357', 'GXTPP5834Y', '132, M.G. Road, Sector 45', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-14T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f3f95ee2a74f', '47c9fd641338f357dc5efe59035cc78a9e87904c04970e2df2c21fdf9a4bffc8', 'b63f6e44d0487e6c97e9e0308f81bad4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_07e5dee042e7', 'amit.bhatia673@example.in', 'Amit Bhatia', '+917640975565', '3383-4568-7027', 'ZMHPW3741O', '630, FC Road, Sector 5', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-20T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_07e5dee042e7', '1f58a0b39172e4df7b4ba67f511fc9c16d5442a3035a680834b8c26df88c52c4', 'f22b2434d664495de5b05b70d3ad9667', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_45165b85dcee', 'siddharth.pandey674@example.in', 'Siddharth Pandey', '+917570350807', '5201-9205-7647', 'UJJPO7749K', '397, Koramangala, Sector 25', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-06T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_45165b85dcee', 'aaed1c493900430858515f7b850381e9026588b9c2ffb8555d35d55b74487ca6', '591918c1c1080fde0249e52243fdccb4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f7144ee56001', 'sanjay.chauhan675@example.in', 'Sanjay Chauhan', '+919277140277', '7994-1973-9965', 'GSUPW4283O', '842, Indiranagar, Sector 33', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-23T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f7144ee56001', '9c59355b26308aff71ec8134b511224d0bb0a8379e6a216f8f3070bbec2f8552', '380267bcafddaf085aab4b500c55ba93', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d56d0ffd4d03', 'priya.bhattacharya676@example.in', 'Priya Bhattacharya', '+917511396424', '5167-6314-3373', 'SMXPZ3651G', '707, Connaught Place, Sector 15', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-01T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d56d0ffd4d03', 'bb6dcd0b2e0004ba4dccc5a4d96c76eff49d4b1002293f0c193627a95c566bec', '2e2d95db39213348a6ff9daf2b335659', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5175bb33e2e1', 'varun.joshi677@example.in', 'Varun Joshi', '+917761856196', '7382-4770-9685', 'AXIPO9185B', '675, Indiranagar, Sector 15', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-15T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5175bb33e2e1', '4761554d1047de67e62accacbbc65658c19419d6ede71ae242832121aa33c8cf', 'c6387cc36059c98a1f2e953bf4ca1297', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0770ff4c21b0', 'aarav.agarwal678@example.in', 'Aarav Agarwal', '+919502720626', '8628-4062-7521', 'JCGPP9976A', '332, Indiranagar, Sector 16', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-29T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0770ff4c21b0', '12598b742c44b4e0c8af0a8f021616d5384625c946a9936fd13aa80e8d6b4c39', '6f4a1ec7facd92f32a55c2e633fad061', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_28e3abc6f3c0', 'gaurav.bhatia679@example.in', 'Gaurav Bhatia', '+918787863682', '6069-9033-9831', 'XSXPK6474X', '797, Brigade Road, Sector 4', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-23T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_28e3abc6f3c0', '87889e07d34e0d01348ca1170759759dce96eee5489b6b694fdf59c972e1882d', 'c010670909fcb6976d9d530fccf8b789', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_947284c42ff2', 'manish.bhattacharya680@example.in', 'Manish Bhattacharya', '+918556999599', '2751-8091-9780', 'CELPS4790G', '3, Indiranagar, Sector 32', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-28T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_947284c42ff2', 'c5ebc175a23339dbd842c55be55e2a039d44c94053c77cf760615707436f4068', '4cb012c8439b220a0b2e2ea95608f5d1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ccdd50cb4f0e', 'rajesh.verma681@example.in', 'Rajesh Verma', '+917707262830', '6732-8810-6388', 'DRXPJ1101P', '613, SG Highway, Sector 45', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-17T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ccdd50cb4f0e', 'c41abb2f6ae778ee9e4f07ceda5b9a788a0a468db7ed3d279464c14d6e81d118', 'fb657b62126a13c0496d2eaffd6e782c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2ab260fdb333', 'arjun.mukherjee682@example.in', 'Arjun Mukherjee', '+919303270200', '8965-4532-4125', 'NWMPH9958D', '952, Sector 17, Sector 34', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-01T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2ab260fdb333', '7dc25cb17fed268b5cfe1798a5babde608e13eb9a2d0a0be83c6563db71e773a', 'e93c12204757a0f2d6a883c4b5845009', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_72d4a9e1f0a9', 'ananya.chauhan683@example.in', 'Ananya Chauhan', '+919539888228', '4199-5750-3568', 'BSRPT1965B', '931, Sector 17, Sector 16', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_72d4a9e1f0a9', '1c741fa80140cf815045a23e90206b46d3e4d9edf9cca54e98ec57e601c8dd49', 'f0c8891232c189d9698a8cf9a6c44d2d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_08dded6c3ba0', 'ananya.agarwal684@example.in', 'Ananya Agarwal', '+919697783811', '8072-6633-3917', 'EEPPP6797L', '756, Sector 17, Sector 5', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.171Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_08dded6c3ba0', '92b00d5725a1dc4617d99a46d8c06a9de6de93c10d95802fc51ad7d4832857e9', '511dd116d6af1c71856784ba4240d1db', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4514bd98ce3c', 'meera.mehta685@example.in', 'Meera Mehta', '+918143326125', '7614-7968-2384', 'LVXPC7113C', '324, Anna Salai, Sector 7', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-22T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4514bd98ce3c', '84eabb6d3974347f035114a0ccd672c8804e2f3c0f28c08838d7679d17c42c0e', '95252684e6013050fca51f083e6d02a5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2da557a4caa2', 'ananya.gupta686@example.in', 'Ananya Gupta', '+919571196355', '9884-9129-4882', 'KLKPK2887G', '503, MI Road, Sector 44', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-20T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2da557a4caa2', '7e50b3f8b99cef0277f079c7bd6e1fd45fb4702167133618c6202573c9e1f741', '3ee6ad5e1b6c527cb5e6d09f7248f8e3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_08e0cc993ad1', 'divya.iyer687@example.in', 'Divya Iyer', '+919165571622', '8080-1145-9735', 'QTVPJ8902X', '954, Anna Salai, Sector 28', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_08e0cc993ad1', '163a543e9aa9de20a240999a44e546137751b61a19752a3d75985cc898aa4878', '5d7c78f23cdfdfbc6629f02f1fb8aa63', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3fb8c40ec616', 'alok.pillai688@example.in', 'Alok Pillai', '+917932615218', '6810-3647-5529', 'IUDPP1815B', '199, Park Street, Sector 21', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-23T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3fb8c40ec616', '96e06bfeeba1ff87583030494c3fbc43262146dee2e411b32ad8fb2484c4a766', '9320f5560f8eb406ec69d3677d247cc9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3dd85c229ec0', 'aditya.singh689@example.in', 'Aditya Singh', '+917758375868', '6613-3328-3065', 'LEWPV9256F', '528, Indiranagar, Sector 4', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-12T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3dd85c229ec0', '4a9539a13e468dd02de94047453254323620ca7953c0f8db0103923f69521454', 'cd829ef0da2492e271769a8dbedc4a36', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cb8ba74e0e0f', 'rajesh.kapoor690@example.in', 'Rajesh Kapoor', '+917790659633', '5568-7052-7887', 'OBGPR5647Y', '846, Brigade Road, Sector 42', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cb8ba74e0e0f', '9cf15a17f02441f5788777772f9a70dd60bc4ef06a4ee94a2ef053f061a55e36', '695dd74c97a05a54ed6a0a426a514324', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_00ac0a4ab786', 'pooja.malhotra691@example.in', 'Pooja Malhotra', '+918435797989', '2590-9778-9970', 'FWEPX1834A', '654, Connaught Place, Sector 35', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_00ac0a4ab786', 'c08273f5fab51c793e16e29f87bac10afc651f068ea5469d13fc064f35585dbc', '004e544b2f12e17130c64fb3a191bfed', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_afb9cf002336', 'gaurav.kumar692@example.in', 'Gaurav Kumar', '+918762796588', '9798-5583-5339', 'SLQPQ9301S', '460, Park Street, Sector 13', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-17T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_afb9cf002336', '976c6a1ca1822360550ae10c1f07bf3754610ce8cf36112e9be00e1c89ccba6c', '2163096ea571151719527d9d239b3764', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_728d016a815f', 'alok.joshi693@example.in', 'Alok Joshi', '+918974554524', '6331-5981-1555', 'BVPPD9832G', '723, Anna Salai, Sector 20', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_728d016a815f', '5f7ade497a88d1b84e805730e4d561fe8513992bb926e682dabe4fae5c983132', '90130d8d3d456b9348f472e3f7cd2a70', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_49f3221ccc54', 'amit.pillai694@example.in', 'Amit Pillai', '+918823557643', '7297-3986-5133', 'TXTPG9309L', '449, MI Road, Sector 3', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-16T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_49f3221ccc54', '16ec320a1dfd5382600ea32be625ddc484cf59f43b01db6393a45a74db9dca31', 'c1dd0177cf179a118f04cf3782b0ade5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_04301ccf822a', 'ananya.sharma695@example.in', 'Ananya Sharma', '+917295942154', '4931-2883-1938', 'QTZPR2240L', '51, MI Road, Sector 27', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_04301ccf822a', 'dd2001f517f62643d70f405abb2f0f11d9109f750b0e8f7879c17e94d7266e62', 'dd5b026c5e883e3d18c3518efa1e5df3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_974641ebe81a', 'varun.verma696@example.in', 'Varun Verma', '+917518633331', '9446-4947-4012', 'TIEPV9912E', '188, SG Highway, Sector 10', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-12T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_974641ebe81a', 'b5fb7fe3e84efaf5af0ae61a89984836f0ced51e0bb6fb93ac58306fba678272', 'ce17f7aa68b90b3525cb039edaecbc67', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_47841ef34f5e', 'aarav.reddy697@example.in', 'Aarav Reddy', '+919212021373', '2756-4221-8034', 'NEWPJ8854C', '134, Anna Salai, Sector 17', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_47841ef34f5e', '13f77c91b6a666a67dbfe514730580a35fec882270b336fd80d883f1825cf585', 'a08a7aff5df6c5be92ea31be0216930e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fe1af4253e4c', 'ananya.iyer698@example.in', 'Ananya Iyer', '+919711196716', '4642-1109-8596', 'KBSPE5186F', '528, Sector 17, Sector 34', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fe1af4253e4c', '6b3d7b70a3548d3857e400395a471aec1352893028b3b492339dcacab9f02686', 'eda485f6705777f0e78a6ce4ed004902', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4d20be398812', 'rohan.gupta699@example.in', 'Rohan Gupta', '+918384476610', '4276-3299-1909', 'MQVPT0306E', '514, Brigade Road, Sector 43', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4d20be398812', 'a7a4e87769df56577c417fcbd952b28a1ac45d6584c4f5d9b92f5d1fdd4711eb', '5ba4b8ed21c8f01993c64faff7913960', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6be9eb0c93e9', 'harsh.mishra700@example.in', 'Harsh Mishra', '+917754585425', '5121-4633-5944', 'GQZPU5178U', '705, Park Street, Sector 6', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-28T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6be9eb0c93e9', 'a6a69da3c981fa2245dcc57ae488514ed9fa9dae2da08e69a3149e95c4e315cc', 'a26bb0c8deae595b6e1bc517dd7f68ce', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_700b320f71e8', 'sunita.bose701@example.in', 'Sunita Bose', '+917828137167', '3363-9800-6282', 'TOYPY9470Q', '348, Anna Salai, Sector 5', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_700b320f71e8', 'd505f4ab42e8b03723e4df33fa784b43568710937d1ce4970ae5437b2206ce3b', '60fba5252db5b08086d310ca2ae6bcbb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8ca9bc010143', 'priya.verma702@example.in', 'Priya Verma', '+917674226568', '8677-6440-3089', 'OADPS1124U', '104, SG Highway, Sector 37', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8ca9bc010143', '1f06fd313094b01c961639a78819ee33cd8bffc260d73d77b43e737946b4d7d9', '6c9095029d1b5e70de6aad9eab53f14f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_db2fce61fbc9', 'karan.verma703@example.in', 'Karan Verma', '+917856599758', '3749-4640-3156', 'FGQPC1050O', '593, Koramangala, Sector 4', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-04T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_db2fce61fbc9', 'a97f7df8f47fc46026016bbd4a78a3ce198ef107ae47beb946dbc5a2881b91c4', '7df2993425acc157be4028dbdfe9f13b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bd7a861eb412', 'varun.patel704@example.in', 'Varun Patel', '+918781245961', '5165-3052-1656', 'WNJPO0410U', '258, SG Highway, Sector 4', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-05T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bd7a861eb412', '7584db1fe48998a206177f6025df9e1b07bff0d7d0e1e890799ceb0b079f83b0', '215f17fb048ef23acae4a0ae295f5421', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_40f1f2037821', 'siddharth.kapoor705@example.in', 'Siddharth Kapoor', '+917516858365', '5255-1629-7338', 'OTMPE5682F', '27, Brigade Road, Sector 18', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_40f1f2037821', '0d9d03264396f20258cfa27f5efa56b05f779bce8e43b49ca41da339f7f0d7ca', 'ef78abecb480fb86a5b99e10696543fd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d742d0c6f29f', 'rajesh.deshmukh706@example.in', 'Rajesh Deshmukh', '+919957540665', '7732-6613-6138', 'JZUPU2360E', '767, Brigade Road, Sector 31', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-19T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d742d0c6f29f', 'f36d12b6d5b091368dce2bcd2873ba91259319296936a204598a7ae13f29f12a', '93714629e249027a8f9f1d01998c6707', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a397e2043d7f', 'harsh.deshmukh707@example.in', 'Harsh Deshmukh', '+919692372849', '4855-3245-4133', 'VWKPW8836G', '550, M.G. Road, Sector 17', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a397e2043d7f', '57fc16828e09f9f813660da1fc55ed058ab3b2f18d7ded6b7668ea4161900067', 'cbb8cd677307ce53dcad322922df1e3e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_40f061cab413', 'anjali.reddy708@example.in', 'Anjali Reddy', '+919488446276', '9826-6695-5914', 'XTUPL4643B', '671, Koramangala, Sector 4', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-17T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_40f061cab413', 'ba75a6447084ededbc3220d98e7536c28308c1e73248bb041b5cb27adfa00199', 'ab2aacb0ddccb7ae86293288880c2179', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a09e61b57d8a', 'aditya.pillai709@example.in', 'Aditya Pillai', '+917897749177', '8510-4371-5067', 'ECXPA6642Y', '201, Anna Salai, Sector 2', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-03T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a09e61b57d8a', '09dcbeab6cdc6deff63c806fdef4e6117339b56e194942b474c0187db6b2e118', '65b8d7a4f2136cb64374a187c67ae51c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d56052e9d3cd', 'harsh.deshmukh710@example.in', 'Harsh Deshmukh', '+919726734621', '2053-6471-5415', 'HYCPL1490B', '703, Connaught Place, Sector 22', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d56052e9d3cd', 'c36e16544320616e4bad4e5cd813504e3fc16dea106ac0ce7b745222896e18ac', 'c2fdbf26af6b832092e78c1375c089c4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_77af4d57c803', 'dev.joshi711@example.in', 'Dev Joshi', '+918692155437', '2222-3759-6724', 'WBOPP0182T', '95, M.G. Road, Sector 3', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-28T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_77af4d57c803', '22b7ff4a6406bb5d4121e1b8219a7982b02449a8518363489c15d7431932f67e', '8f2081487b1b37df618ea357ecafc4e5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a3545f629e6d', 'kavita.sharma712@example.in', 'Kavita Sharma', '+919766442606', '2575-4494-6082', 'VOBPA9510I', '529, Koramangala, Sector 20', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-23T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a3545f629e6d', '28bd4c3621adca3c5825062ea91cd43b262fa8388274192adad518596dd6903c', '875825cf44afb06fcaa0b6492d33dfd5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ff016c7dc821', 'alok.sharma713@example.in', 'Alok Sharma', '+919969855972', '6183-4753-3718', 'WKBPV2675A', '960, FC Road, Sector 40', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-01T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ff016c7dc821', '77a68eacd87fb70e0f984ea6f6a6a7bceb6ce46fec007dad83db31da332bd71c', '4e96b1c87481cb3e2dd511130f4be216', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9755a684b96b', 'ritu.mishra714@example.in', 'Ritu Mishra', '+918398428378', '9652-3567-7438', 'EMPPS8470F', '603, FC Road, Sector 4', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-07T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9755a684b96b', 'a4107e137762d8ea2de49094881acbdd90d7b06231aca5dd11d9c30f9ae812a6', '8ee81e396f7062d000cefd8163d153fb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a9a1a4a75c93', 'dev.menon715@example.in', 'Dev Menon', '+917597993951', '4230-4276-8001', 'LYMPJ6218U', '451, M.G. Road, Sector 19', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-04T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a9a1a4a75c93', '4ebbdc584a2860e9f5e64217b767a2a28cf2a31c6484c94f5b01df3f86269cf0', '6dbb1c517ac283035ca555e2dcc2d4db', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6b907f205b32', 'anjali.mukherjee716@example.in', 'Anjali Mukherjee', '+918429233218', '5301-8782-9252', 'JLNPJ4001A', '288, Banjara Hills, Sector 10', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-29T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6b907f205b32', '7ff2d05ec297d753165df39d045923bcd15c35c3ed63c4b2ec296f9e765bcd5e', '2022c336c2511ba71ff2467ddff99b74', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c1a09566cea1', 'rahul.iyer717@example.in', 'Rahul Iyer', '+919459447612', '3004-4617-8507', 'HVFPJ7471S', '304, SG Highway, Sector 10', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-04T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c1a09566cea1', '3981492bdc57b10236680383dc94cd9c725dacbfd5ca6e5af17d92d0588079e2', 'f0c9841cdca736ac3e9305b34c03b1c6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_95c3e46cc5ba', 'gaurav.agarwal718@example.in', 'Gaurav Agarwal', '+918691681716', '7418-8111-7905', 'AVKPQ2115V', '53, Anna Salai, Sector 3', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_95c3e46cc5ba', 'd2b7cf9812b21d8ad90ad0f7a2ed2503623a491dbd6b9094d84b1fa134af65fb', 'b75d1f42c7971bacbd23fa38acb2e709', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3515c35f1b49', 'neha.chopra719@example.in', 'Neha Chopra', '+918455764413', '4009-3338-5402', 'MFRPM3891O', '784, SG Highway, Sector 6', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3515c35f1b49', 'f6722fba8798cc3f5c326d3856805aba62e548ddf59a954554a8a2c938b1e249', '901fed3b6aafd329d3a249671562575e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_305d2224143c', 'varun.chatterjee720@example.in', 'Varun Chatterjee', '+919199259805', '8194-7685-4760', 'NAJPN6021V', '244, Koramangala, Sector 45', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-05T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_305d2224143c', '71d777c27e28405d58dd7b3da1f510c7b161082f7b1b452278153c5108996af8', 'bef09fa0d31814d79f42422c5fe8e5e2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e03b9ed8be4e', 'harsh.chauhan721@example.in', 'Harsh Chauhan', '+917409928921', '9509-3641-9634', 'MCMPQ4562C', '313, Banjara Hills, Sector 26', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e03b9ed8be4e', 'e424a9d2ee44ce4ce195b70ef3fda8af71f4bf5b24423bbf88c9d36f00d250d2', '927e7d1eae7e1d11f6f840ea2b7db863', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a6d217f3b561', 'divya.kapoor722@example.in', 'Divya Kapoor', '+918337976272', '8994-5040-9995', 'KBXPN6557T', '649, Park Street, Sector 40', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-27T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a6d217f3b561', '3f5733a5ec427fd442974bcfa3ea40a364ff7d2fb5fb041db28d18e7a50e2f08', '13bd049f3688eabf8c207ba4a98cb8e6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3e3c8da3edd2', 'tanvi.trivedi723@example.in', 'Tanvi Trivedi', '+918600794264', '8237-9824-4555', 'NNEPB5112R', '303, MI Road, Sector 25', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-09T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3e3c8da3edd2', '5019574c2898a7ee955131f5c9b7e02d8c076a53f73c562901515de39d46d9cc', '48df331ba21d60b398e0386bb7432966', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_55cf8ecb5932', 'siddharth.verma724@example.in', 'Siddharth Verma', '+918401940464', '8766-9880-8165', 'LPKPE3115R', '208, Indiranagar, Sector 37', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-30T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_55cf8ecb5932', '80fdabd8b2a38b8a3e1964ce7b4eb642e197eb69cb594097ca06f3fbc80ce3f7', '3cadeae8df08966d8402e3f02a4fd162', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8398fb8d9872', 'kunal.iyer725@example.in', 'Kunal Iyer', '+917156263999', '8682-6148-5043', 'MOAPO5868J', '225, Brigade Road, Sector 42', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-17T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8398fb8d9872', 'd7196be9ac876773a4ba0364bdf5da738b4c959f968de946728adf94a75d35f7', '5e575ada8ceccb11d90a703b0a8ad609', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa583a26a5ef', 'varun.trivedi726@example.in', 'Varun Trivedi', '+917163891471', '5104-8398-7030', 'KLGPO1163K', '746, Anna Salai, Sector 34', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-11T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa583a26a5ef', '82f2b5d7c652224934b3e6bc74c06f53e7582893cc51db865016a07ab9c7914a', 'a39956e90a5454b1817f3dc6b0a36d2e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fe1cb720db23', 'simran.reddy727@example.in', 'Simran Reddy', '+918100198885', '8469-7169-3788', 'UVDPG2393W', '534, Banjara Hills, Sector 11', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-20T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fe1cb720db23', '7ce4192c3efa4d66832411a3078e7edf466867d98e2b130b5e8f7cb1cf96bff9', '292c8047dff548e4aff7cc54d4d5430a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6ccb8725b8c7', 'divya.mukherjee728@example.in', 'Divya Mukherjee', '+918641501663', '2789-2815-4880', 'XNVPE7065D', '32, M.G. Road, Sector 19', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-02T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6ccb8725b8c7', 'f6c8ddbb00079981e4a7f55ec6a905c786b2ee547a4cebf2e9236a6976823fbe', 'c38011546b7c7c1a93151c3bbe91703e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1c84dbea8b46', 'rajesh.dubey729@example.in', 'Rajesh Dubey', '+919281920742', '7756-6816-3506', 'ERCPU7316W', '763, MI Road, Sector 15', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-30T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1c84dbea8b46', 'd49a6d68920264862928f38827e8b529381c4ead5eaac781f166e16fdf5980a6', '9e6dc3f42ec5123b808d55e6d1e8d213', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_022a2489fc38', 'manish.bhattacharya730@example.in', 'Manish Bhattacharya', '+918608378395', '9827-4706-5914', 'HMBPK9919T', '198, MI Road, Sector 13', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-11T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_022a2489fc38', '35e873ad99582f36e8f4e4501c0ed935a441610d0fd2dc5eebf2ff957ba9c145', '463607433d5ef56ae2ef806cceb178c5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_113628187b4b', 'alok.reddy731@example.in', 'Alok Reddy', '+917413767393', '3689-9346-8291', 'WBPPL8086O', '443, Anna Salai, Sector 19', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-01T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_113628187b4b', '9ca3174c9708f4449bd592f184d3cc568a47122e61837baeffa4bcb9a7494321', 'd45310fbee69e6aa6bb23be158809d5a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fbedd4020c3a', 'ananya.chatterjee732@example.in', 'Ananya Chatterjee', '+917379502907', '2746-9009-4203', 'OUQPY4876B', '477, Sector 17, Sector 28', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-26T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fbedd4020c3a', '333f94e0c00571a58dca1eedbc013b8368b219083af2b535dbafd7a3e17bb310', '076f4383783da7fce8f3ce88b747bca9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d1d83cae2c63', 'gaurav.kulkarni733@example.in', 'Gaurav Kulkarni', '+918114889477', '2737-1003-4105', 'FYNPU6304B', '686, Sector 17, Sector 4', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-16T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d1d83cae2c63', 'c6f767141256b71714caa85a543d81af36bd75b687064d5a8c5f08070364c2d8', '342561095c697747d6f5a26df45c8c2d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_82ae99ef9071', 'rohan.dubey734@example.in', 'Rohan Dubey', '+917615693768', '8156-5875-6432', 'CYUPR5779R', '446, MI Road, Sector 32', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_82ae99ef9071', 'dad61b52f8ebce34f07833fa9283a555c4cec2b03409bcbd9ef8bd509c9abf18', '3bcb10ffc179f3662c3af78a96b7e7e3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0415cfca815d', 'neha.mehta735@example.in', 'Neha Mehta', '+919686203347', '5400-4930-1270', 'XCYPW2268M', '175, Park Street, Sector 2', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-29T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0415cfca815d', 'a38785a168d0f86981ce7e7ac1fbce006f2de171580305cbba8a72617aa3639e', 'e346017babe9b87d619217b3e0e6a302', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c77aba4a1688', 'ritu.saxena736@example.in', 'Ritu Saxena', '+917266425566', '9191-7664-8138', 'EANPO2434R', '676, Brigade Road, Sector 16', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c77aba4a1688', '30f2670de9f4d362b4357ba92532fc42e3b888267acfdee97c9c89bf3bd256e0', 'cecfec37adb5f88db419e0cd5c47aef9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c92054dbf980', 'sneha.joshi737@example.in', 'Sneha Joshi', '+917198596761', '7607-9449-6020', 'UAXPC7806Z', '99, MI Road, Sector 16', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-27T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c92054dbf980', '4bddfc6bcfcd0b8b4be40e8428a7235c999eb9bfb0f0962ae7f75f8ca921e7eb', '895b4da6f6fd67c74bb9dd52bd09069a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9ca3b60acb26', 'deepika.joshi738@example.in', 'Deepika Joshi', '+918724925124', '9128-6950-4029', 'AYBPN9109P', '420, FC Road, Sector 5', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-29T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9ca3b60acb26', '05f24393f34bdf191eecd256c9b593e984e09df668e2da8d686a8737a759ccbb', '0b8a335cd2bed5b4252f1403635dd417', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2157958dcc12', 'neha.nair739@example.in', 'Neha Nair', '+919732151620', '6647-8011-8780', 'YKPPJ4772C', '334, Anna Salai, Sector 35', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2157958dcc12', '8d1d89b1ef93609619aa983cf2cb7eccc7445f14851faf82e95d416f5554b99f', 'c115c1bdb12a5f0a4cac95763ec7305e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fa5fc499076f', 'sanjay.dubey740@example.in', 'Sanjay Dubey', '+917538072726', '9488-2499-1403', 'QQBPL5070N', '741, Park Street, Sector 8', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fa5fc499076f', '35650ffa88c2da9085e31d1acadbdfda0b443b508b0c491acb008601ff245ad3', '9e8351e39dc5f30fa045e8922226d1ec', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3cbc4c5d205c', 'sanjay.mehta741@example.in', 'Sanjay Mehta', '+919277612736', '5303-1511-6517', 'OLPPD0577W', '795, Park Street, Sector 7', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-28T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3cbc4c5d205c', '79533a9f8ad221beb81845cd33cb221a2563924fdd79350eedc4912e1b88b9b4', 'd072e2fbf4b62b2f0a45be4196570a67', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7fbc01841138', 'ritu.singh742@example.in', 'Ritu Singh', '+918761861939', '8292-4302-1797', 'SSXPV1127E', '637, M.G. Road, Sector 2', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7fbc01841138', '24c7ff4ad476a5b0e6be94b3a4f47e5a62136da51c345473aeca2ca010a47f83', 'd4f0fac7b69292cadd725c7d96e2506c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_58be21d3dcb3', 'kavita.kapoor743@example.in', 'Kavita Kapoor', '+919363009702', '9332-2153-9535', 'NHPPR3538B', '283, Brigade Road, Sector 43', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-28T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_58be21d3dcb3', '2ee18a42c97ea7c983d8569dbe28f5f733208ae26b1564c364defc325250a225', 'e6ffc01556fbb747c81c1b44e4b2e232', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2cfeb523022a', 'bhavna.mukherjee744@example.in', 'Bhavna Mukherjee', '+919796577780', '6983-1909-8073', 'HOMPV4830R', '707, Banjara Hills, Sector 7', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2cfeb523022a', '04855cebf995152aa5bffffb76897e46733da193a9a82c3e92c4ec6f38989304', '962a290aabbc9efb3e97cc5a1f8c953f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a853c6b25dad', 'ritu.saxena745@example.in', 'Ritu Saxena', '+919966792163', '8221-3127-8722', 'PUAPA9065H', '195, Indiranagar, Sector 18', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a853c6b25dad', '36e0e22cfc00f0cde7a972f56a41d808ccdb32f71c8eae69d3fca9479326ba8a', 'e26579f0bb1ac9079696000a13fd54ff', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4b6f25b078a8', 'simran.chatterjee746@example.in', 'Simran Chatterjee', '+918336176482', '8417-1775-2342', 'GCFPF0085W', '780, Banjara Hills, Sector 38', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-22T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4b6f25b078a8', '6ee116d9df8a6506c1228a949910203d06522c28b69af627b4d8b85438e0cd71', '7c6575a6f4461f7197b6e5cd8ecd70dd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_dfa1d0772961', 'priya.pandey747@example.in', 'Priya Pandey', '+918727445746', '8907-9525-4601', 'PDHPE5444B', '962, SG Highway, Sector 15', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_dfa1d0772961', '3660bbdceaabbd86c9fe11150eb8d16446ae51472946e3cccf47f30b2423ec37', '0ca157598450d7ea95020f437b5244d7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cc888fb992c2', 'isha.chauhan748@example.in', 'Isha Chauhan', '+917245018327', '9202-2317-5899', 'LJRPX9385D', '944, Banjara Hills, Sector 2', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-01T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cc888fb992c2', '04b28d5a62d99d78594d324b455359b4baf9aebc406b37971ea4f567e67b14a0', '11ec8576386298cea19505a5365b2204', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0ee3bf209f34', 'sunita.mehta749@example.in', 'Sunita Mehta', '+918995711705', '4883-9273-2468', 'PSCPF0151H', '911, Banjara Hills, Sector 38', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-19T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0ee3bf209f34', '0f9717a2e4f2f5a0c0418ab00a114c95f4d857e21eb2a8d265e11c17d06e69a3', 'f18582da2a695c45ef55acd09d3d1fd9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_15a8c667b902', 'sunita.pandey750@example.in', 'Sunita Pandey', '+917629050956', '4146-6526-6606', 'SXFPA8651I', '964, Sector 17, Sector 11', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-27T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_15a8c667b902', 'ff3e42833d38473786576b3819bca259cadcb41e06538bf25a89f4c0af9f6487', 'bc508c1ddbf281c617f1e7f4a01b1959', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f63bad277322', 'tanvi.saxena751@example.in', 'Tanvi Saxena', '+919435417438', '8375-4710-7268', 'KXDPD8795Q', '789, Koramangala, Sector 9', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-23T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f63bad277322', 'cc2f2abd43fec857f12b5f301ee1327b1f69bf28d8693685153b3a94c856d6d9', '41c5ad73db1e73a1c58fd3eeb20af961', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fab7d1ee676d', 'sneha.bhattacharya752@example.in', 'Sneha Bhattacharya', '+917699750637', '2695-8926-4078', 'BBZPQ5714Q', '230, Indiranagar, Sector 19', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-30T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fab7d1ee676d', 'b9e4e8185626f22c26753f36d7f47fd02069e6ea4d0cc226d02e8d30225374b5', '952d2dda275e023a7161a900a9c8744c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_eb20fe824bbf', 'gaurav.verma753@example.in', 'Gaurav Verma', '+918813540025', '5672-2403-3973', 'OBVPO8665J', '328, Brigade Road, Sector 13', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-19T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_eb20fe824bbf', 'bb9ffbfadaf319c565fe9f35d1184eff7d36f6507a120942182183ad51091082', '9d6d1c173b68482f6914bdf6555dd3ba', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3a202f4d6300', 'karan.iyer754@example.in', 'Karan Iyer', '+917990224298', '8327-1680-7223', 'IEOPO6671U', '495, Koramangala, Sector 22', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3a202f4d6300', '43358f16a8f4482419bcff2d28574a815df646d2d21711cbfbb4967ee0f64252', '03f89165d93063890249d3508d6f616d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ad8d951f87b0', 'meera.kumar755@example.in', 'Meera Kumar', '+918703724908', '4571-1588-7633', 'HQWPH2059Q', '608, MI Road, Sector 19', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ad8d951f87b0', '813e710ff5bf44a759809521404dd6040d8b6bdef2f11561d3bfdcb4c640b5f2', '8fb418788f17f325a7e60f87846a9d9c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7195d42ab192', 'manish.saxena756@example.in', 'Manish Saxena', '+918137186814', '3257-8398-5064', 'WLPPD6567U', '368, SG Highway, Sector 11', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7195d42ab192', 'dbc8285c40d665bedc00c85c2dcde246a711cf07bde36ed9207dee45a85d2934', 'b4a54842858ea854c114d35ada9286eb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_153b19e68902', 'alok.pillai757@example.in', 'Alok Pillai', '+919930815174', '2249-6176-2000', 'CJVPK5751M', '454, Koramangala, Sector 28', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_153b19e68902', '89c8e86243c9e9a281592a0c17092ffcd9df501a0b6b083f679a86eb3af2075c', 'c2c98436468c5b69e0ffbd099786bb9d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f8f400aafbaa', 'divya.patel758@example.in', 'Divya Patel', '+919179298747', '8219-2269-9299', 'WRHPG8893V', '865, Koramangala, Sector 15', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f8f400aafbaa', 'fce865b5db8e27ab90ea2bf223a4b06521b4f4ed47f368408ea2aa9561a34ae9', '002290dcec1ebe266af53e87e3d2bb64', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_118b88295cfd', 'harsh.malhotra759@example.in', 'Harsh Malhotra', '+917517063275', '2819-6001-5912', 'BSLPL9343P', '382, MI Road, Sector 33', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-23T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_118b88295cfd', 'ba9188d4241e2a621b64c0d83da58fb69ff17d63f6c94ef943d947375a385233', '46a7dc10f6b6d983389231f8a8f9fc4b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e23d98097225', 'neha.saxena760@example.in', 'Neha Saxena', '+919149620447', '9936-5238-2941', 'NLLPY4950O', '593, Brigade Road, Sector 9', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-03T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e23d98097225', '7adece632c97418bb815a3fbd38530378070da0e3908499ceb646e74169f7502', 'fcfb5cb7c29910299136e570c87a9f93', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1a39c758e6e3', 'abhishek.patel761@example.in', 'Abhishek Patel', '+917123128171', '8256-4907-9445', 'PAXPC9044E', '761, Banjara Hills, Sector 37', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1a39c758e6e3', 'ff60479b6638f3d774b2bee62182a8894235fdb5c8ff92b08175600d07b08f30', 'dce9564d787159d33b761f2949be6b6e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f8826a09e38e', 'swati.gupta762@example.in', 'Swati Gupta', '+919561699518', '8138-5241-1532', 'RLUPE7309G', '3, MI Road, Sector 5', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f8826a09e38e', 'af4809137c2fdd3d286dd76c8bac9d7442512148a8137117ba4412ebedaca2f3', '65710df6c1e976d3719a01db213cd784', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5233dc89dccf', 'ritu.mishra763@example.in', 'Ritu Mishra', '+918548962172', '4588-1222-5816', 'TRSPH7653O', '670, Banjara Hills, Sector 40', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-26T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5233dc89dccf', '851057e2ad13d4138c88f9e23d8d668f1a06546ca6b22826395da92f713c786d', 'bc4bc72f69d01a169fb1f1a9c11171fd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_369105fe2f32', 'nikhil.malhotra764@example.in', 'Nikhil Malhotra', '+917729453273', '3129-2746-9993', 'TLHPW2152A', '957, MI Road, Sector 5', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_369105fe2f32', '7ee188eaaa6eddd4f2a556d38da152098acd74f113e1fd8f99f2636564c359cc', '7e969030954f9fd414c3045305683b2b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f8dc598b8540', 'ritu.kapoor765@example.in', 'Ritu Kapoor', '+918165788487', '7526-5282-6878', 'FKUPZ6069E', '559, MI Road, Sector 7', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f8dc598b8540', '511f18771f0ad79b1f1c90e4b32a663397e5d5f0f71bcbce73c00c859669a3a8', '770a5444783242ead533f6d8aa0563fa', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_922e14968f9f', 'pooja.singh766@example.in', 'Pooja Singh', '+917597938261', '8851-8521-3172', 'FYPPL3547C', '796, Connaught Place, Sector 9', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-09T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_922e14968f9f', 'ab91beeb397d0b2e8ce330405f6ba4fb85e9933972769dad92a42fb8fc263b8f', 'ab7d47ce0fbbfec09744c6c3e84ee118', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7c1bb588d5be', 'isha.pillai767@example.in', 'Isha Pillai', '+917479220022', '8900-5693-5433', 'WQZPC4710Z', '989, MI Road, Sector 30', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-01T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7c1bb588d5be', '0dde0dbf4368ec46ab6e83de5e550ca2f49793e36d93f5f7450a2751b2b1d056', 'f65149e377bb8152edcfa053d6dd8ab6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1e3b76022a57', 'rohan.mehta768@example.in', 'Rohan Mehta', '+918499037329', '9370-7583-2322', 'SZSPT9252A', '163, Banjara Hills, Sector 25', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1e3b76022a57', '3cef8071077b83462e5605077eba8418742d4f7a02a5af6fde9a51d9ec99fc6a', 'a1cc48b30a6fac1c5638dd6bd1add5ef', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9f0bd41b0f7c', 'pallavi.chauhan769@example.in', 'Pallavi Chauhan', '+918795832116', '8430-4706-6780', 'QSXPP5092A', '829, M.G. Road, Sector 32', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-30T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9f0bd41b0f7c', '20441c13aa7935b5cf45c6b163e9e944f674ba36a851f98e4a65b616d0039cf7', '362757433d3aba5b3e1afd60e5f51fd1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_65a321361195', 'isha.pandey770@example.in', 'Isha Pandey', '+919979542098', '6074-7070-8578', 'RJTPO5262F', '960, Sector 17, Sector 26', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-26T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_65a321361195', '7f628b1aa121181d94c2d1032a923f62ecafe77cd37d5d3594503059567faf93', '7a9fefbb4bb797c603aeef48c7867951', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1d09d708c4a1', 'pooja.kulkarni771@example.in', 'Pooja Kulkarni', '+918766937869', '9239-5591-1864', 'QUMPB3928C', '427, Brigade Road, Sector 17', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-27T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1d09d708c4a1', '7e36b3027bef41b3ea8ec290e1a0a60336214bf109d6a92addaba579ba305d65', '4f89c2170145fd96ef48ba34a1150ef2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_be0aba66caa2', 'karan.malhotra772@example.in', 'Karan Malhotra', '+918295878798', '6461-1289-9290', 'WMUPX0185I', '911, Anna Salai, Sector 35', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_be0aba66caa2', 'd7bf0996609958316265471007883a6a9722caeb2655cf57a7304616a804945e', 'bf36ab48d9c4824853c4e814fb1ce863', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d60db65d0e06', 'ananya.singh773@example.in', 'Ananya Singh', '+918157838953', '5169-6059-7786', 'CAEPW1528T', '584, Indiranagar, Sector 27', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-10T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d60db65d0e06', 'e5513e60f48eb469159bf4d928107cbd7762a07d9d8c54d48f02e4ea6935586e', '2a7d7ff0d5878a51426d17fd724ca6f0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f6b7ff790cf3', 'pallavi.reddy774@example.in', 'Pallavi Reddy', '+919686336196', '8371-4105-4695', 'NNNPS8638W', '889, M.G. Road, Sector 8', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-17T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f6b7ff790cf3', '03e80360e4e6aadfbe62ed916d9204ed37447822941e6e13909ca4e8d7f01010', 'c53ecc542949351f71bfe0c715436e4c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_19e15b107520', 'tanvi.nair775@example.in', 'Tanvi Nair', '+918408606738', '2311-4769-7081', 'BFJPN9375L', '805, Banjara Hills, Sector 28', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-22T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_19e15b107520', 'c7b1a7ae2a5be93a506c0d54edda57fcbbcb9895ff9bf0991e2eb60c646b0579', '0e96ea1730da50bcab281fcde84d958d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6622a24c7748', 'dev.joshi776@example.in', 'Dev Joshi', '+918216124176', '7542-1408-2733', 'LYFPL1203G', '322, Park Street, Sector 34', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-23T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6622a24c7748', 'a1fc3431acf41d394fc0a4a3175d35ef350e7e9a7b0288e3c6e2df0871734db8', '3d126e4484e1633898a7cf9ec095e6d1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5cf69dcc5e89', 'rajesh.mehta777@example.in', 'Rajesh Mehta', '+919647981754', '4400-5672-2758', 'IVUPP5561N', '566, Koramangala, Sector 3', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-14T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5cf69dcc5e89', '94b463e10fd63fc05aa7124b8a9c421a4953773824a88c32081410beb541b6ed', '6a834e1a8e1014bf92512b8f11baf553', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_75d7fafece23', 'deepika.pillai778@example.in', 'Deepika Pillai', '+919856177545', '8767-8568-9909', 'OYSPF9625M', '373, Connaught Place, Sector 34', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-11T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_75d7fafece23', 'cb35b8d3777c045a1d3cb9d77867df64108623faae5dd71d7e9364bf2220e8f4', '4f33b08b9b188f8457478f3b192c5b73', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_24a767cb6781', 'karan.iyer779@example.in', 'Karan Iyer', '+917383154302', '5581-5715-4431', 'ESOPT7619T', '34, Koramangala, Sector 13', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_24a767cb6781', '9f735a0119d2e157678570a77143d2c529800a59117e895d336027e1f00cb86a', '03cb13f00e079248ed41f0e29322d299', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_612814f079d9', 'harsh.patel780@example.in', 'Harsh Patel', '+919403142098', '8379-8836-8220', 'GXPPG4063F', '29, Brigade Road, Sector 26', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-18T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_612814f079d9', 'b9a69a7d270b5525ee2d23cd4e4b175b34d2fb67d495edb2faed48964888220f', '0f19b58bbac904a8dc0b468a90159678', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3c0aed5d3dbe', 'sunita.saxena781@example.in', 'Sunita Saxena', '+918249707375', '6711-4273-4660', 'XQLPG5327Z', '937, Sector 17, Sector 15', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-25T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3c0aed5d3dbe', '6cf879915e5ee763d0953100aa4f55275b2724b74682f44f1b5796d2f7d060b0', '1c218a17071eaa19ae7163b94f49cb48', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_374d6fc82166', 'nikhil.kulkarni782@example.in', 'Nikhil Kulkarni', '+918786206061', '6171-8618-3100', 'YCRPH0176E', '172, FC Road, Sector 40', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-16T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_374d6fc82166', 'a56f405f7bd6d1bc231b6b189e06ed52bcec41f3935d979ded1029bff2a96b46', '9ac06ba01acea6168e86a4ebf488f71c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df34d9b97522', 'bhavna.singh783@example.in', 'Bhavna Singh', '+917585709861', '2810-2531-1889', 'PGKPU5405S', '547, FC Road, Sector 21', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-29T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df34d9b97522', '661fce739444985308f10dfbc7d09cbdece590d348ff352dd39de915aa867403', 'bb57ec75856acd232d0808e2751de340', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_73b0a7d5fc53', 'rohan.reddy784@example.in', 'Rohan Reddy', '+917396804671', '6013-2306-1658', 'EMJPO4660S', '75, Anna Salai, Sector 32', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_73b0a7d5fc53', 'c56a2fe0cc0dbec15f041e389ae717b6136b160b48454e4faa4b4a052d37785e', 'b4380b0e411ce3b7da4d70b947799c93', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa31c0f46209', 'neha.verma785@example.in', 'Neha Verma', '+919791786897', '9828-5687-8467', 'VRAPO5915Z', '981, Brigade Road, Sector 42', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-13T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa31c0f46209', '194a00b2f7fea0888059c8f79fc371d4eb8ea28ecba3748b20e56ec4bbd7fc05', '5280aab8c06fb05ea9efb68fa567ac30', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c1a1990d3035', 'shweta.gupta786@example.in', 'Shweta Gupta', '+919490025343', '2145-7419-1341', 'UTSPS1494T', '909, Anna Salai, Sector 22', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c1a1990d3035', '984b008758699a3560b7346b5f9b05635763374ecdb8d868bfe555b2f745b4cf', 'a3a090bf84a3b61d6766a944a1060ea7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b12d1eaf9b00', 'arjun.patel787@example.in', 'Arjun Patel', '+917172863424', '7203-3661-6470', 'ZOUPN4519K', '618, Park Street, Sector 9', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b12d1eaf9b00', '9b04cdea157d7fcac66d29697af90c0ebdfb5a05193ac1bc8ebd3733d31df0cf', 'a9194cc3f0ea2de6da953855e882b616', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_33faf6b450a7', 'karan.mishra788@example.in', 'Karan Mishra', '+919650957345', '8692-1328-8238', 'HINPS7977F', '734, Banjara Hills, Sector 35', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-18T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_33faf6b450a7', 'ac5287316c48317df79a5cd47e750ab1cfd1bc32e6e7c3c384c101faa491468f', 'e44fc14e106cba18bcfd168a9c196d8e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b445dabfe3b1', 'gaurav.sharma789@example.in', 'Gaurav Sharma', '+918739923227', '4846-3920-7723', 'YGFPD7893C', '607, Indiranagar, Sector 3', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b445dabfe3b1', 'a3abdc84cf687c85645adee95af67ec0b5be2a3b55dbfd44ec7e5ede504b0774', 'd641e5dd70de31ab61c12f1905eaf919', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e80126fc933b', 'aditya.menon790@example.in', 'Aditya Menon', '+918386389598', '9815-5366-2646', 'IVSPS4617P', '126, Brigade Road, Sector 45', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-14T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e80126fc933b', '341c423b1685fc5c9e4db7791b57f73994a640c580d9ebecd82c4f3b75765352', '9d0aa5a88399884022131662f6d75b3d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7b1c509a969b', 'ritika.malhotra791@example.in', 'Ritika Malhotra', '+919992931308', '2742-3173-5762', 'VCIPG0421X', '659, MI Road, Sector 31', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-23T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7b1c509a969b', '83ae4e1f12d0233284ce9fd77ff0300246d65857e74ae8a529ebc36222767322', '26cecb87d823d7c52bfc93b7c96a25b0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4eeef4620d46', 'arjun.chatterjee792@example.in', 'Arjun Chatterjee', '+919745604467', '3356-2615-5337', 'CNCPR6177E', '957, M.G. Road, Sector 35', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-20T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4eeef4620d46', 'ccd46eef8e4d22ff10456b73005c58ffec3575651eb9c0051a9a6b39d0bd1993', '32ef952fe0eb6be0a66394ea3abe2584', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d912c96ba5ae', 'dev.kulkarni793@example.in', 'Dev Kulkarni', '+917213602253', '3092-6063-3235', 'PCZPI7996G', '512, Brigade Road, Sector 32', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-28T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d912c96ba5ae', '98c9b1c370e0037158ba36e07cda615b1cfb95677f9ca13fd02987526812db9b', 'd0d14d38b759761fbc745d3aff506348', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_444d25d5d093', 'kavita.nair794@example.in', 'Kavita Nair', '+917980470928', '5426-1109-3845', 'OKOPH9779S', '856, Connaught Place, Sector 41', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_444d25d5d093', 'e57e299c8a6276e1e9e02bdd2986c32a9d652994d7ffef74d82c2531a76359c1', 'cf7f82e2883aec617cb9ab1e76618868', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1f2dc12ee8df', 'ritika.kumar795@example.in', 'Ritika Kumar', '+918500063292', '9068-5926-2983', 'YIUPQ7728V', '242, Anna Salai, Sector 7', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-02T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1f2dc12ee8df', 'eea13c493c2d0c0245bcd6bb0b97a258a8bbc3b2d3dbfc9adc98e9a7f5b9eba2', '322983e7f335dd80024204f3623fe2d5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3ff0138678df', 'sanjay.kapoor796@example.in', 'Sanjay Kapoor', '+919377647813', '9700-6766-5190', 'FHTPF6024I', '916, Brigade Road, Sector 5', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-25T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3ff0138678df', '636c089cc5c9c4c1b38e278918a02b9c5d4141a338c23cb1d3c06c7ac378ee89', '3afcee226c91b038198c8934cd879ef3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cf2b257a9f5d', 'deepika.bhattacharya797@example.in', 'Deepika Bhattacharya', '+919320477376', '3287-8957-7861', 'VDWPD7334N', '360, M.G. Road, Sector 14', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-05T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cf2b257a9f5d', '7a59daccc5513d2d7ced27902b9e783e2ffa0268802423a99f43f3a9620d28aa', 'fda8b458ed3e3f8edf78280bb3de6ae6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d05f7c452268', 'gaurav.dubey798@example.in', 'Gaurav Dubey', '+917901340974', '8731-2584-9612', 'BTSPG3137P', '494, Brigade Road, Sector 14', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d05f7c452268', 'e2ec0cff872d4e1bf95b1383c55ee6bfc7f6b9619893ba7e8f50561d4eadfcca', '3f716b543f0ae6223ff4381ceb493c64', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e171105f5601', 'pallavi.dubey799@example.in', 'Pallavi Dubey', '+917868361522', '4290-8230-3693', 'HFXPY0571H', '484, Brigade Road, Sector 14', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e171105f5601', '2984188de8bebf4b07232614412a0624d8b8fd1d08d8c5eaf5d65bab9e1febc0', '87ffb69ac050e912e41d75ed11066e17', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e4df1c99048a', 'ritika.pillai800@example.in', 'Ritika Pillai', '+918982037970', '5722-9945-8175', 'RQDPG1586X', '463, Brigade Road, Sector 7', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-24T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e4df1c99048a', '0bf42051dacc4283684f198daf7b14e6928eb8f6573272e0525c9006b0f3e5e7', '2eeb6f0f1a97f948461c53b0792badd9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f1142d75c41d', 'deepika.bhattacharya801@example.in', 'Deepika Bhattacharya', '+918869868715', '7857-7938-1161', 'PAWPE6927K', '594, Park Street, Sector 18', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-14T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f1142d75c41d', 'b84f5442466b285485f2dafb182e08a1ea444d958a92afd3fe9298840c80e599', 'd592d1fc86ffd1b4c9f0710c6238446f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c04679648a78', 'harsh.pandey802@example.in', 'Harsh Pandey', '+919684793407', '9544-2434-9635', 'ASDPI9442Q', '870, Koramangala, Sector 41', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c04679648a78', '90b834c0e082103c5286f9535df2429f490c68d79d5065b4e334350b7122d9dd', '09147ce49ed06c73003a45bfd493fad3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8d76f99347ae', 'rahul.kumar803@example.in', 'Rahul Kumar', '+919133389161', '5801-7591-4356', 'VCTPB3656X', '347, Anna Salai, Sector 36', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-08T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8d76f99347ae', '2ac858d9801edfaa52b178ed9cf781074e0cfa1b965670b8b63f0f85fc2d29b1', '0aace219ed1f2bc52e9ff8fedd4a11f8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa5f4a7f3997', 'deepika.bhatia804@example.in', 'Deepika Bhatia', '+919290614072', '8654-2398-5768', 'BRUPA3656D', '108, M.G. Road, Sector 4', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-05T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa5f4a7f3997', 'f4f457d5d49c9d87898553954248ebcb3649e45e8a9606ffdaf793c9443ec636', 'dfacf565d6c315e23af7332e70db5fd1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0a0f78e801d8', 'ritu.singh805@example.in', 'Ritu Singh', '+917896864525', '9535-1258-7751', 'TRQPU0948R', '383, Koramangala, Sector 25', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0a0f78e801d8', '49d106c92916eb79a1891bcf1a9fddb02ef81da6b1002dc281021ac9f45967aa', 'db06865f5d41db1c78e0a29249c5a5cb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_88d0051b64b9', 'kavita.dubey806@example.in', 'Kavita Dubey', '+917991177392', '3376-9520-7689', 'WBJPG1579B', '489, Park Street, Sector 5', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_88d0051b64b9', '202f715998092b42c6031537ee195b62ca0fa699ac21da814d830ee33d7b4371', 'a9c1bb56273ec67d27b807562e196874', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cb3adcb00070', 'rajesh.bose807@example.in', 'Rajesh Bose', '+919566713452', '7019-1139-4450', 'KFWPR9753S', '836, Banjara Hills, Sector 32', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-14T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cb3adcb00070', 'ed3d1eb020fd23a5d3a1092d91e8a00eecc96b890ce2d6ff035bdcc80bb892d0', '8c88dc568ce2c5d4d63fc01900d2554b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4b579cf33586', 'rohan.nair808@example.in', 'Rohan Nair', '+919627965946', '9675-4997-2581', 'ZVGPC6895W', '118, Koramangala, Sector 40', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-06T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4b579cf33586', '9f8e2439b513862754863056d605f764e25d71767cfbc3a6e8e5054582fad3bd', 'a67843f6d39f6fcff6a926cca642515b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ef40e455b1e2', 'simran.malhotra809@example.in', 'Simran Malhotra', '+917567908745', '7824-3717-1049', 'SUTPE2506D', '340, Brigade Road, Sector 14', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ef40e455b1e2', 'd83b4427d3e6be52304cc5d8a501238e2874d2d0412fe9bed2b1d4229c228d51', 'b1eb928030cd5c1b6bc5b75a41212069', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_08e31a357270', 'divya.nair810@example.in', 'Divya Nair', '+918767252572', '8834-7534-1703', 'FNXPP4519I', '734, Anna Salai, Sector 38', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_08e31a357270', 'c1c1e8c9d9cdf8f18d37affcd3f296dad4f457a6692632f3306fce7203d18467', '5f65c29f2886aceefacbe87dd4f4ee01', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_76ac1c558ed8', 'vikram.sharma811@example.in', 'Vikram Sharma', '+917407929081', '3596-3940-6298', 'RXTPO0580W', '234, Park Street, Sector 35', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-03T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_76ac1c558ed8', '9a1fa4ffb153ebff9008bbedbbdc25e80428f73dacee371df4e00a35cad285b9', '2e9439c8167fd33a727c68872bfa9a3f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_09e48433bc61', 'pooja.saxena812@example.in', 'Pooja Saxena', '+918881912318', '9252-9044-7006', 'TCJPF8109K', '56, Indiranagar, Sector 19', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-13T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_09e48433bc61', '519fb2b8b276b60f1405226dffbf6e627cfb414bb26f3ce3dccb498e16f72299', 'ef7d7715c68df7cc4788497aaa083165', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bba2f7e61aa0', 'priya.malhotra813@example.in', 'Priya Malhotra', '+917983646246', '3210-9530-7449', 'WFQPK7650X', '628, Indiranagar, Sector 42', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-21T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bba2f7e61aa0', 'fa42cb24a607270d105764de4fc0ec0fc42adaa4ca461b29097422b335de81ef', '089de19e56b2aa673f3caef545485fbd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_103624651147', 'abhishek.trivedi814@example.in', 'Abhishek Trivedi', '+918536585504', '6651-9778-2648', 'MUDPS9927B', '467, MI Road, Sector 17', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_103624651147', 'f214a084f0c0f3dc5f2a159f35911d5c1de1a8092cc92f64c21a388798dc8cf0', '81316a0b8d7195c01ca596e1967116bc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ecd47d664fa0', 'kunal.bhatia815@example.in', 'Kunal Bhatia', '+918268989809', '4042-8804-8933', 'ZKVPK6989C', '26, Connaught Place, Sector 27', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-09T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ecd47d664fa0', 'df14789d0cfabd7bba74b8c3aaa64674f4145192038d18b7b09ab2051b925e3a', '86a8d5461f11ccfed0a2e9fa09262128', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_04b81adbc7b9', 'anjali.chopra816@example.in', 'Anjali Chopra', '+919690082695', '9150-7535-1021', 'RJLPI1323Y', '895, Banjara Hills, Sector 31', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-04T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_04b81adbc7b9', '2eacbc7197465be8842762bab1d47c09565ea816d21c84557d708f5810ac4ee0', 'd1337620661472625a532bc475216e36', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2b5629367121', 'dev.trivedi817@example.in', 'Dev Trivedi', '+918858627471', '8532-3521-5670', 'CIUPO8271B', '692, Koramangala, Sector 22', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-10T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2b5629367121', 'c5bad7de69d0a084941b188a54fd7dd9acec230aa92e36a56dd6d10705b2db43', 'c67508002b66e677ec89b827e7c7ea67', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_20e94a0c024f', 'manish.menon818@example.in', 'Manish Menon', '+918788574669', '2078-7557-3965', 'YBIPZ4333O', '102, M.G. Road, Sector 11', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-15T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_20e94a0c024f', 'b49d7f47bd1aaa230c018c68917699e17f33bba45da88250c0c33baa05bd5051', '746657b2f4433042bee790d31e689aec', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fe488ed2401c', 'gaurav.chauhan819@example.in', 'Gaurav Chauhan', '+918555991516', '4441-2247-6438', 'CNIPK6411L', '846, Banjara Hills, Sector 38', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-19T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fe488ed2401c', 'e289dd0fef515f9d1f90eece96b4b47c8f2d5795fd59a52307e2b6bc70bfe651', '1e8e55f6f86494daa48bd7c64d211a10', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9309e1349923', 'tanvi.singh820@example.in', 'Tanvi Singh', '+918702717953', '5661-6589-5938', 'XMTPB3838H', '778, Indiranagar, Sector 13', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-17T10:59:26.172Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9309e1349923', '5142ea658445b73c4b450a994064b469ff480f306f06a6d1b138197df7d1b607', 'f60ddea045f85951174e2fd00ea37514', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c6045e8d0416', 'rohan.malhotra821@example.in', 'Rohan Malhotra', '+919214808197', '5571-5782-7745', 'ASCPQ4766Q', '348, Banjara Hills, Sector 6', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-20T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c6045e8d0416', '7fdfeb252282e04886c7b4020e34a0d78a362949ff2d9add769cf0058b68258d', 'bea20b9900644cb134cd81dff36086cb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4a52b368e683', 'rahul.bose822@example.in', 'Rahul Bose', '+919615589639', '6645-6065-5185', 'IWZPF7717H', '548, SG Highway, Sector 10', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4a52b368e683', 'd27f8e9028bba64d07be29ee353fae953fec439b1a609f485f9efb2aab07233b', '9176ba6156522dc244a6a3bddf7bec9b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9f9f1b4bbeb3', 'sanjay.mehta823@example.in', 'Sanjay Mehta', '+917567619596', '5711-4864-9027', 'VWPPA8088U', '336, SG Highway, Sector 43', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-02T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9f9f1b4bbeb3', '08f380adf60636a66b4dda914d879eb2114eef0451ed678bc5bd6cf76d4e1b5b', 'd4f5b94c3c5620d85a3cce0dd3fa9a45', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c70cd40dc3f6', 'vikram.gupta824@example.in', 'Vikram Gupta', '+918408464788', '6222-9296-8135', 'EFUPK7579R', '557, Koramangala, Sector 3', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-29T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c70cd40dc3f6', 'f4dddc188c653f704eadedec045db72b135c32f298d3eb9fdc2e98b7735ea687', '54a78cc49a0a0d9ae46a7d60a2cbbb37', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f36f592a73d5', 'rahul.sharma825@example.in', 'Rahul Sharma', '+918625773596', '2924-2669-4742', 'KQHPN3900G', '889, Anna Salai, Sector 26', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-06T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f36f592a73d5', 'cf208d1c32f283016f232b643be21135fe61158ddcf7927db781f2c8701848fe', '08fbcf9db45ef1bba3447e83df2c09e8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e0d29baf7782', 'ritika.bose826@example.in', 'Ritika Bose', '+917995821483', '4714-7992-2216', 'MZXPI3979N', '578, FC Road, Sector 16', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-04T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e0d29baf7782', '7b4a0b2fce8a111aff4206707eb55c40db55c3578abb84de5741a5b11eaa742c', 'c0c64c3815efb8ad2f375e308f0e34d2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9fc6d8d69d0d', 'vikram.joshi827@example.in', 'Vikram Joshi', '+918731062481', '9506-6268-1849', 'UKBPD0835D', '715, Sector 17, Sector 31', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-27T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9fc6d8d69d0d', 'e9cb45ed254c30b4c9dcdb38621ecbf144f42242ba6da692414de761eee94608', 'ab5a3c1f4d63fac76494499c2db81649', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c3da1ba371d0', 'amit.bhattacharya828@example.in', 'Amit Bhattacharya', '+919908519600', '4494-9229-1112', 'OVOPH5288T', '121, MI Road, Sector 16', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c3da1ba371d0', '51ad5b0229d550c689723de5d2d8ab58634fe8e03c8f4a96ca2fd076e60a78ef', '48a5b9d7676dd1d8903a62eb47a3e44f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8a5b265f3c62', 'harsh.chatterjee829@example.in', 'Harsh Chatterjee', '+918739770000', '8287-4995-4912', 'INQPE6157D', '711, Connaught Place, Sector 13', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-15T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8a5b265f3c62', '8959ca37b54489f60e8040a85b1acb74fa6d32b1387e7e41c9d9f43abfe76da1', '961484c620a346bb86db461ab60068c1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_58cebbcecebe', 'rohan.menon830@example.in', 'Rohan Menon', '+918699238157', '7458-4770-8712', 'ZJCPZ5370S', '852, SG Highway, Sector 14', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-12T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_58cebbcecebe', '1e47ed069e5000367d556be29b83a5130eb906d5ee48c46871e990837b490c77', '6af43532748548b77d432ff1cae6e92a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c75a4a80f2bd', 'nikhil.iyer831@example.in', 'Nikhil Iyer', '+917511004685', '5682-6367-1491', 'TQVPY5423D', '608, M.G. Road, Sector 10', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c75a4a80f2bd', '64974c5dab517be07a16e2b2fb5026ff991a736d3177a40fd3e6c3a37c906a6c', '28c1fac501973de15c524911c17e50a9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b8d2e99e46ae', 'tanvi.chatterjee832@example.in', 'Tanvi Chatterjee', '+918118992422', '4079-5743-1316', 'FDHPY5566U', '411, M.G. Road, Sector 25', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-05T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b8d2e99e46ae', '8afd19f6fa531bf7336a44b4dd13524c5f3423ca10f2f394199e5cf599d9b8f1', 'a3cdf56ac877af60542200949884d85a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8d64e811e728', 'alok.joshi833@example.in', 'Alok Joshi', '+917459748625', '9671-4399-1314', 'YVTPT8881R', '811, Brigade Road, Sector 32', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-16T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8d64e811e728', '9c6fdd8d7c6c144259a67050ebb28753343076e1ae13df0a0d5f75edb99a3361', '8abb93fadc1030a44e90a8845570bed5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_70b945a6a717', 'rajesh.bhattacharya834@example.in', 'Rajesh Bhattacharya', '+917678391909', '2259-9330-7745', 'EDJPC2578L', '197, Brigade Road, Sector 11', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-07T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_70b945a6a717', 'f706992ead7d153f071fa2ec935357ef4cc9c93f753816fd13a83da3fb51136f', 'bca6170dc759a09f2d312f6724975a83', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_60fcb108685d', 'gaurav.mukherjee835@example.in', 'Gaurav Mukherjee', '+918379578176', '5544-3097-4753', 'DIDPK9504V', '372, Indiranagar, Sector 34', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-08T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_60fcb108685d', '38ec46f17b7bcb04579b99b72ece28f0c053aa0ff7d62dcbef8661d544fd1859', 'd43438d66277ae243834b5aec172aa26', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_48bf54e498aa', 'varun.chauhan836@example.in', 'Varun Chauhan', '+919796681781', '4467-3720-8810', 'ZTTPF7215N', '261, Banjara Hills, Sector 13', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-15T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_48bf54e498aa', 'b0425c28023f82ea7a3f398becdf3b14576faffd699c1fdd0ac3c88fc3489dfa', '8ee045775c2d7ab4f18872c942db7644', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_02c8e4dc8a6f', 'rahul.pillai837@example.in', 'Rahul Pillai', '+918854105526', '9540-3836-8117', 'TWMPZ3211Q', '708, Koramangala, Sector 31', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_02c8e4dc8a6f', '8a990f56e42c38508f61f255e0741ff9715f49dd72498b30ceabebb69522808a', '06485134ce917e75a31328621ba7889f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c4456ed8b4c2', 'shweta.patel838@example.in', 'Shweta Patel', '+919987288919', '8305-2476-6529', 'ZZLPM1343C', '503, SG Highway, Sector 26', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-12T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c4456ed8b4c2', '30db9ddf540d7c5b314b0c232c177e54e7ffc1fd0a1a6597a7a228babc28a95c', 'f503e3db4aff3160bdb36d4f09b5bbcc', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fb460a6c0e12', 'priya.trivedi839@example.in', 'Priya Trivedi', '+918610795381', '8832-1598-6156', 'RJYPK1208W', '722, MI Road, Sector 30', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-27T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fb460a6c0e12', 'e95e195e8e2cf8c4d6b127c34229cc823997c25a256fad8a05279e72654fd660', '594d2a3c9f45def7408e4123e6c9856f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e5113b5bd29e', 'rohan.pillai840@example.in', 'Rohan Pillai', '+917929522948', '3581-4331-6847', 'MKEPW6513Q', '835, M.G. Road, Sector 20', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-20T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e5113b5bd29e', '42fb55b2de020018acb401d23cd188b931b4214a98c532eb02ea7d96fd4493a9', '825f004ea3341cce5609294c4f64d5b3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b744ffabf415', 'tanvi.saxena841@example.in', 'Tanvi Saxena', '+917906230865', '3537-2744-9907', 'RTGPW4856X', '799, Brigade Road, Sector 23', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-19T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b744ffabf415', 'a6a3693c0e980aeeaa1416b546ae6ec2f7a0cc9d6621898d186239760070a9f2', '62185c1cd97c732d5862743b15b93308', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3da60ed7d06c', 'meera.saxena842@example.in', 'Meera Saxena', '+918861626438', '3270-4413-7132', 'BBCPC4084B', '398, Connaught Place, Sector 22', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3da60ed7d06c', 'adbc18e8d03443ab1911dcfb73785999e26494247ae58b6b731945f9237fcee8', 'b8b307ec5839199df093c6ffc0ffed2e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e55da9315b34', 'ananya.trivedi843@example.in', 'Ananya Trivedi', '+918925068997', '5289-4061-6158', 'DECPF6411E', '64, MI Road, Sector 13', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e55da9315b34', 'b8416c10e941bdbfee88fd8171839e4653b2534bd61ce7b2119b01ef512abe07', '69223f7dca340b53af56816bbc80496f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1ac6cb32c049', 'deepika.bose844@example.in', 'Deepika Bose', '+919870199358', '7655-9166-8935', 'WPTPN4351Z', '403, Sector 17, Sector 43', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-14T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1ac6cb32c049', '382ef6f768ad1949b6404293b8c40ddb8dbcb273fd78cad818657e9a88c26704', 'a937f26a56e7a44b1047942d77ea796c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5f9f72729125', 'kunal.malhotra845@example.in', 'Kunal Malhotra', '+917205511675', '7749-2809-9169', 'FHLPC0441U', '637, Park Street, Sector 35', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-26T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5f9f72729125', 'd0d0e302079f9ea0ddb42f680ec939f5223d8f7b8761c0deee2dbf972788b416', 'ad6e76840e825f9b7e6e4628ad1c0daf', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_146d642a5261', 'divya.malhotra846@example.in', 'Divya Malhotra', '+918553790586', '5454-5448-1744', 'VNDPT5385V', '880, M.G. Road, Sector 25', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-15T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_146d642a5261', '3711cf7cb7a8531aaccdecc3ad670113da8cfb8a1993261492f914f61754248f', 'feaa0964cd98ab9a05b2b8f550a91210', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1d2dd69e1e41', 'rahul.kulkarni847@example.in', 'Rahul Kulkarni', '+918895302341', '7799-9982-4625', 'KVWPV2337M', '35, Connaught Place, Sector 38', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-10T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1d2dd69e1e41', '7e65e5bfa8db8257118c28282aef3feba3494f0165163b81334b3c9e42300f11', '9a393c759c36ced63b4f241bc8a18e89', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e4de2d3ac492', 'priya.chatterjee848@example.in', 'Priya Chatterjee', '+918384422555', '7287-5411-2810', 'NJAPR6101X', '185, Banjara Hills, Sector 21', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-12T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e4de2d3ac492', '10ae2950e6bba545a65e01273cdc08fcbc104f4b661a400714958a7d94ac0b80', 'b460c285863d8f1891c67b6c7f1fb1cb', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_58e43e99d5e7', 'siddharth.mehta849@example.in', 'Siddharth Mehta', '+918593641978', '7437-5336-8274', 'VWCPF7184X', '845, Park Street, Sector 3', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-02T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_58e43e99d5e7', '647f9d2a4d6c975a221e2daa9dfda34a42e51014676915c05571740f40413bff', '29d29f13a48931a9be5d74ebb4626763', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f446ccbfc0d2', 'bhavna.kapoor850@example.in', 'Bhavna Kapoor', '+919635218816', '6711-7331-6489', 'DXRPH1634P', '731, Park Street, Sector 34', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-31T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f446ccbfc0d2', 'aca69c272d9f264d486d6d3c09109c48382b01b71f886ff9c8069f351105c5be', '47727fab60fdc37a81132029c15d996a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7ab67e38936d', 'dev.patel851@example.in', 'Dev Patel', '+918344177275', '8474-2637-9131', 'GSCPZ0331A', '503, MI Road, Sector 14', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-01T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7ab67e38936d', 'eff2436e77cbaed345bf20074d807d270741a0bdcb9cf0219a030574e1fcca93', 'e6285ee6a8b64170bae05ce79975d6d5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2bc5cb6490e5', 'abhishek.reddy852@example.in', 'Abhishek Reddy', '+919197811685', '3997-6553-2096', 'GKHPI8718T', '848, M.G. Road, Sector 45', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-09T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2bc5cb6490e5', 'c5415070874f511439f57371810703caada592cbd5067b17289e5c9b997cc180', '1ab5e2eb3e26ba8d4bd99043a29c2a6d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cfd7d3829c87', 'isha.bhatia853@example.in', 'Isha Bhatia', '+918553351962', '2897-5578-1343', 'LIDPR0723F', '979, M.G. Road, Sector 30', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-08T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cfd7d3829c87', '171823661165e9bc8c7bcd081fbac69eba47c8925c4945290dac7d3387ee506b', '2f650d20bc34c1a944302d5247b6fc27', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c6ba9081194f', 'nikhil.deshmukh854@example.in', 'Nikhil Deshmukh', '+917696515847', '8785-5340-4039', 'UXBPQ2516F', '650, Connaught Place, Sector 20', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-11T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c6ba9081194f', '81136daa2fd75e8c6a06580f52e8cfe74ff8a7f6da151223b1267541c405f01d', 'ab5549330a8906a19bf3f11283676021', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9e354dbb8c58', 'aditya.mukherjee855@example.in', 'Aditya Mukherjee', '+918912341739', '5979-6271-9305', 'DCOPG1340Z', '525, SG Highway, Sector 20', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-02T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9e354dbb8c58', '369e7fe67fc39176298cbb778c4873292364cd1055ac46a77beffb61dbb6caf3', '0fab49bfba644d47e202c3f271c4b80a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_902ce57803ef', 'deepika.iyer856@example.in', 'Deepika Iyer', '+919535043412', '6052-8917-3023', 'LQOPJ6418J', '768, Indiranagar, Sector 2', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-28T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_902ce57803ef', '1af446ab7962589b5e605d4de92851256822f46c370192520882243e416a99e8', '4f38d8bbd7cbbf66e9a8c73ac02dfeda', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_31bbebbbc10b', 'dev.gupta857@example.in', 'Dev Gupta', '+917998007841', '5204-3583-2512', 'RFLPG6136V', '624, M.G. Road, Sector 3', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-26T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_31bbebbbc10b', 'c32925b010ee99c9d27c02e5724e31d9630b0432ffda7984796b15afd42fc3b2', '9af6f2d91d994598fcd190fd0d21fe43', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_acf4397f597f', 'isha.pillai858@example.in', 'Isha Pillai', '+918469582087', '2441-1007-4193', 'GZAPJ4264N', '757, Banjara Hills, Sector 39', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-31T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_acf4397f597f', 'b3b7e314ca919bd00f3cc02289b66ebcb56b821284ed6849fe681bf621f275ea', '2e61231bab960b8f5a39004048357af5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1e0f0fb910f9', 'ritu.chauhan859@example.in', 'Ritu Chauhan', '+918937856490', '9646-4353-4819', 'GDXPX1265X', '130, M.G. Road, Sector 43', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-18T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1e0f0fb910f9', 'd7f7ba991c50ed42363d4c92abdc2618ee8da66070351f7f65471da1290f8201', 'fe99f16eed89507995c948506a00ed29', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d1e6c10ba0fb', 'simran.singh860@example.in', 'Simran Singh', '+917293896879', '2900-8700-3733', 'JSWPJ0797B', '598, Brigade Road, Sector 38', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d1e6c10ba0fb', 'd042b842353f93a395957a63188b48ab5e180e675a1c876a4e7b3634b7dfce0d', '870f85802554a4e43d6049a354affb3f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ebb9173eb85a', 'dev.mukherjee861@example.in', 'Dev Mukherjee', '+918668175720', '5660-8943-5633', 'MKJPT5972T', '753, Indiranagar, Sector 2', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ebb9173eb85a', 'bc64613d6e57228d487baa8178b56e3bda2a34342fdb91ff7489156a3ff0321e', '7283903b5c1dec6fe93a33fe46fa2243', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_482e54332a04', 'shweta.joshi862@example.in', 'Shweta Joshi', '+917583867058', '4261-5589-8910', 'DMUPL3507C', '713, FC Road, Sector 23', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_482e54332a04', '46b6928712510e7669d0c8c462aeb0048f535c9834b37b806461f00213877021', '8d3e14d49fe171ba38b595fd477541f6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_513c6d73f074', 'amit.trivedi863@example.in', 'Amit Trivedi', '+918869702187', '7403-8012-2591', 'EREPW3651W', '416, FC Road, Sector 16', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-30T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_513c6d73f074', '9460c7a7bb82f885a06ed2b4d8bb3f01db291ce32cd4f02c26082e8648356379', 'a9b6c3e2a5c078966a1d641fbd4e82aa', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cce1daaa3471', 'shweta.iyer864@example.in', 'Shweta Iyer', '+918907260402', '9070-4263-1957', 'HIYPZ9598Z', '286, MI Road, Sector 29', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-01T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cce1daaa3471', '0f739ba09eaf124385fbef69f636dd610c88f97e50dd2ebede4228f7d7480b48', '202ba5319e52c29be9d6110a8779bef4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_641efe05097e', 'aditya.nair865@example.in', 'Aditya Nair', '+917692140338', '3921-2586-6299', 'MELPX3121H', '965, SG Highway, Sector 23', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-22T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_641efe05097e', 'aa1f0e570468f1095a318f0efe7627dacf89bcd09f9106d02c2543f09ac343f0', '9e7dcf58073b7df31645e18368c2b070', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1259958e1bf5', 'harsh.mishra866@example.in', 'Harsh Mishra', '+918687398934', '4127-9822-7952', 'CWYPT6821M', '270, Koramangala, Sector 42', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-13T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1259958e1bf5', '6ee5605aa136c03a9f54c9914fd3148f495e4383f2b228e50f08e1b0a58c5fbb', '0ac07d2ce11bd6fea1b76700917d4302', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1a629ea629dc', 'sneha.chauhan867@example.in', 'Sneha Chauhan', '+919776016866', '6196-6318-4092', 'BIVPT4377F', '618, Brigade Road, Sector 21', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1a629ea629dc', '89d93851825a80bc4d9f2293690c1cbd4ec2ac4d34252f1d217068c9d77c4f6a', '39b57eedbed881f38565d3832c3fb755', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3534ef02e50e', 'arjun.menon868@example.in', 'Arjun Menon', '+917508768093', '8229-5803-2410', 'XVLPY8767Y', '642, Banjara Hills, Sector 43', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-03T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3534ef02e50e', '19a8d5ff743f5cfe77a9ad8d642d6ad736b6e5a1ae5d62991346629d5af43ccb', 'c08bcf6576a55102cf04ba7890a12898', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a0a53639696a', 'divya.trivedi869@example.in', 'Divya Trivedi', '+917244240808', '8942-3449-7375', 'HJBPR2932P', '559, Anna Salai, Sector 4', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-05T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a0a53639696a', '6af7f2259dba1309de949862fa4a1ac42e50cbf3ca612cfb38fc834d6f4d76fc', '92a3c46a5cfa103397990b1f5aaf6dd2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b82ada21b033', 'siddharth.sharma870@example.in', 'Siddharth Sharma', '+919429031395', '4066-5591-4787', 'NZZPD9396W', '504, Koramangala, Sector 19', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-28T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b82ada21b033', '96daa58fa02f3ae55009e1dbdb7123c7fb68d670e7bee34afb4e31e5e74cd762', 'e4bd23606e72d6a267df8d804b7a80de', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c38de9b82294', 'rajesh.dubey871@example.in', 'Rajesh Dubey', '+918307714606', '9195-8183-4298', 'HIFPG0264W', '490, MI Road, Sector 7', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-28T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c38de9b82294', '9151aabb9edfc297aeaa4b2eef921be4ad4b46bea17fcff645b3fdbfa881a693', '7b2e18637098c78a2f4757f180940fda', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cca880869b66', 'priya.bose872@example.in', 'Priya Bose', '+917802194511', '5146-7845-3864', 'SZYPO1381T', '241, Indiranagar, Sector 13', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cca880869b66', 'd052a090462963c26b959b13ffc87d171fc9b8af86184691caa0b901604a0a70', '43aa586d1ecd674e1f35fccb97022b51', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cdb562c889ec', 'arjun.chauhan873@example.in', 'Arjun Chauhan', '+919139180226', '8755-8178-6300', 'BRTPO9787J', '549, MI Road, Sector 29', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cdb562c889ec', 'a137b3773846ed83f0bd0f955660b790d8e03149a68a1cfa966e130eda51d489', '7b9f4072a51dcad7a04606dccb8a8409', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f0bf004ff850', 'pooja.iyer874@example.in', 'Pooja Iyer', '+917256471386', '3153-7494-5463', 'YLCPY3493M', '152, Banjara Hills, Sector 6', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-05T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f0bf004ff850', '42d43a781279ee024cad8140e4148e4872a8b3c9b4d574d1a60d7b0d931323d3', 'e4c51953607d06d3118e96bcc60ebf3d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_08d076fca981', 'kavita.singh875@example.in', 'Kavita Singh', '+918177878692', '9100-8599-2617', 'UTXPN5299H', '343, Sector 17, Sector 42', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-07T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_08d076fca981', '8a553b0a66130bcef141350b4d10b4a2ffda5551d3fd1cf4ee6fed7e21b7f481', 'e03d8ee7634f8fd5f5a547be06cfc3d1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c8492e298337', 'swati.chatterjee876@example.in', 'Swati Chatterjee', '+918493456936', '3533-7625-7308', 'WJKPN5770P', '527, Koramangala, Sector 42', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c8492e298337', '070354c02700fc237f73d958a7586ddaa26a9852a6aad9851cb038850a2cae6a', 'cf3f98809460ebf25335bd35116ac811', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e295caf59dd0', 'vikram.iyer877@example.in', 'Vikram Iyer', '+918974412207', '9592-7954-8930', 'SYQPD5328Y', '813, Banjara Hills, Sector 28', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-11T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e295caf59dd0', '0e4700091c4d0b3f4e79b1e4064b9f10589229d1fe325b87ed709ad584eb3932', '3d8c2d26edf10763367245376127e45e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0fe57da8e1bb', 'nikhil.kulkarni878@example.in', 'Nikhil Kulkarni', '+919992187446', '8470-4850-9643', 'IWKPF4298A', '314, Indiranagar, Sector 22', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-10T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0fe57da8e1bb', '8c5028c1db8f0b373af5763a7e39ead8a4665d006f831fb7bbc513be43849f1f', '6729ac7488f72460a4fb461bb66f7823', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a004bc8a8cd0', 'kavita.rao879@example.in', 'Kavita Rao', '+917354962820', '9333-1249-3404', 'URDPE2649B', '859, M.G. Road, Sector 42', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-31T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a004bc8a8cd0', 'fb6bb9b60ba447c88aaaec14d65c36e447b67ee8dfa781056c6f19a02650a70b', '7121fe93232d177e174182793e1d8341', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c60dfa5f0928', 'abhishek.chatterjee880@example.in', 'Abhishek Chatterjee', '+919493941303', '9342-3463-2420', 'LQBPK0371S', '347, Anna Salai, Sector 35', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c60dfa5f0928', '8a49d6d367938c7e1d5b48dc34a2ec699dab4734ddeeb3fc1c00fb9e986d0967', '49d7330b03bf3850ae99a989c0a91f78', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7351da2d5536', 'rohan.verma881@example.in', 'Rohan Verma', '+917256406609', '2803-9126-4275', 'EHXPO1068U', '972, Connaught Place, Sector 34', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7351da2d5536', '8321ccf186e0811ba8fec4da1a50d4435d11c91ce9f9e25958912326b48e9d78', '510b6949121ce6f66ad14bb0ea17d625', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_811017298e27', 'deepika.sharma882@example.in', 'Deepika Sharma', '+917291020280', '5356-6627-2121', 'DVFPV1060T', '441, Koramangala, Sector 44', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-30T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_811017298e27', '2a403dc5e16aaf810bb77d0a3341bf243e5926a5ee0dbde12aba56ac250d91fe', '4739aba59cedc7616a5eaecaca210989', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8236460c3a79', 'ananya.kapoor883@example.in', 'Ananya Kapoor', '+917973109374', '5537-1855-3353', 'IFCPV9645I', '209, Indiranagar, Sector 40', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-31T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8236460c3a79', '7af2eac4fe5f45dcc67feafa4996e20c2038ecf66d6d66d371bcf8a9430f912f', '20fc7322e9fde5bd573e4b3a6bcef629', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4b0ce9f4beb6', 'isha.kapoor884@example.in', 'Isha Kapoor', '+918419678504', '5883-4793-6821', 'KDTPK6324N', '714, MI Road, Sector 32', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-04T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4b0ce9f4beb6', '8058bb4fdefa9b8622b7c8bf7588e7cc1b129494232287d302eaf4a94efad4c3', '58ca3973fd388b40231b2e6f0b8ad82c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_011de4603145', 'abhishek.malhotra885@example.in', 'Abhishek Malhotra', '+918961367679', '9118-6163-7462', 'ARPPX2040F', '663, Park Street, Sector 7', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_011de4603145', '871118c62e0fd5b59c2ce35e5faccad7fd580ad08c9e1a7d95721f3efc4cfdc8', 'd548d1f19d17f726d93f87fef26101d1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b490570af7a5', 'rahul.menon886@example.in', 'Rahul Menon', '+917344172409', '5684-1979-2263', 'GWDPE6614V', '169, Koramangala, Sector 32', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b490570af7a5', '106babaf5f05719c744b4c172748c32cc35032235861520023e773a56ba4e346', '1708389776aea3965cab458ab9a26b29', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9c5d7b383913', 'shweta.kapoor887@example.in', 'Shweta Kapoor', '+917832300295', '8416-1719-7076', 'GYXPM9224U', '751, Anna Salai, Sector 18', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-15T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9c5d7b383913', 'f5442310171aa5970d4a2392bb2d00e874ad5aefc02d5bcaf48a1666b280d475', 'd899d2c6d39cf57f3513774517500389', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9c40bd978496', 'aditya.deshmukh888@example.in', 'Aditya Deshmukh', '+918876689411', '5139-7573-9524', 'QIHPL7317P', '691, Park Street, Sector 8', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-18T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9c40bd978496', 'b666470964521d1bbe6f0fdc1a747abeb2fcd05f03183b35b9cf485f9da16694', 'a8cc37f79214d3f59ca7f194d6712bff', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_aa9031ec35ab', 'neha.nair889@example.in', 'Neha Nair', '+918377963475', '7963-1299-2017', 'DRIPN9774I', '595, Park Street, Sector 28', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-14T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_aa9031ec35ab', 'e3dd668013fa189257de61da930a28dbb4b0a7bb7a83757e9d5eff3b9c2feab4', '7b4a41e6ccd004a5419176aac51e5dc7', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a7d9eef08a36', 'aditya.reddy890@example.in', 'Aditya Reddy', '+918545769291', '2220-5370-7994', 'PFIPY0788A', '623, Brigade Road, Sector 38', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-08T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a7d9eef08a36', '5cd70846fae4b5a42506b9fa1ba017ddf4fb878b2d67f1b29d4fd29611f04d5e', '2a37bd76341655068280b5142729f8df', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_77ee66717918', 'aarav.gupta891@example.in', 'Aarav Gupta', '+917846949826', '3592-1460-9203', 'UMPPC1412E', '412, Anna Salai, Sector 8', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-19T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_77ee66717918', 'ae9e18f51481edbc5c48e3e35f80dd6881bed3383960352212848dae523548cb', '7bc5cf2841a9b818a6afcc22710bf7c0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0ed5c1da06d4', 'aditya.patel892@example.in', 'Aditya Patel', '+917707580946', '2661-4642-1731', 'PLGPL4906R', '44, Anna Salai, Sector 36', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-12T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0ed5c1da06d4', '7665df0868c77a6060942c35d004b40e6edf93528c085bce61cb3c0044e46030', '5dc83908522179ca15bc48e311a4b4f9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_862e876e4dcc', 'nikhil.verma893@example.in', 'Nikhil Verma', '+918708181549', '3375-7315-6512', 'ONMPT9713I', '273, Sector 17, Sector 11', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-06T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_862e876e4dcc', '5ad9746cb9cc3e5b47bc1bdbb5bbee14c3955db521630dd6aa62892673d75dec', 'f0aee2f614b5431bfbe88bec4da6f606', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ad30c6276faa', 'gaurav.trivedi894@example.in', 'Gaurav Trivedi', '+917125632438', '9472-5152-7941', 'SCUPU3166L', '213, Brigade Road, Sector 13', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-07T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ad30c6276faa', 'bfa279f918263278a5de4e003e0ad7e0884a91c163cda2e876ce6add7d689ef6', '3143294da30c9d74b2d0a0fc518094fe', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1cf5d07fdfc1', 'rahul.agarwal895@example.in', 'Rahul Agarwal', '+919248709313', '7123-6867-7828', 'JMGPB2202C', '370, Anna Salai, Sector 38', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-29T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1cf5d07fdfc1', 'dc225e6b8e971f9d8e4bd073338f2cf78d516c7a06b751a4a47fdbfa60f926cc', '591e7a8be9cc4f7b1c8e20cbb5b94a31', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b9e5fe8e74a2', 'shweta.malhotra896@example.in', 'Shweta Malhotra', '+919802575915', '2945-8394-5678', 'DKFPG5723Z', '513, Indiranagar, Sector 18', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-08T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b9e5fe8e74a2', 'e86101315819a8d33d75c99a7d6938e751b4471e13acd1f3b7504be6a894fdb3', '5a79a439dbec03dcc17268762900a6b9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_841a8d7fd8d4', 'rohan.menon897@example.in', 'Rohan Menon', '+919574741762', '3433-3037-3105', 'PUSPB7425Q', '241, SG Highway, Sector 9', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-17T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_841a8d7fd8d4', '86cd90f351eab463f68908e0f0f592ec4170aaed0fd883fa5fc8069d3d829b7b', '7a4eeffa69ac0afcf6c85506e86eafb8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_df71c8e37b99', 'bhavna.chatterjee898@example.in', 'Bhavna Chatterjee', '+919946936982', '4781-7279-5405', 'NFGPP9339X', '40, Koramangala, Sector 11', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-30T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_df71c8e37b99', '0280c8767f471854d458cc1bc9a2857fe8a2fceff47b820e6e68f542bccb3c6b', '37f19e7e47ba9743ba96b416d85f672c', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_695c67a0916e', 'gaurav.agarwal899@example.in', 'Gaurav Agarwal', '+919437577471', '2013-2252-3445', 'ZJJPU6762Q', '563, FC Road, Sector 33', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_695c67a0916e', '2e53ad6d810279944517e6f957d17368955af39ace55a22dd1ba3eb5f512119e', '77109fac8fd069caa45a0e5862d41cee', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bb49c0a308b3', 'nikhil.agarwal900@example.in', 'Nikhil Agarwal', '+918880626997', '7660-5244-1470', 'RWNPA7474A', '825, MI Road, Sector 13', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bb49c0a308b3', '0ee240f52c39c8258939d146a99f31cd33f309c74816f0f648703d6f2c2b03b3', '0da1294f350a695cb2f440eeedbf2f39', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_fac302cb9b30', 'gaurav.menon901@example.in', 'Gaurav Menon', '+917877490656', '9292-6326-7756', 'RYHPN2848N', '572, Banjara Hills, Sector 11', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-02T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_fac302cb9b30', 'd1055c08dd4bcbeb9a0d1c82fa558e850faa6fadb66965e93b78784b510b2c6e', 'c430d04f78f27fde3930b79ea2567f15', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b7229f609622', 'sanjay.deshmukh902@example.in', 'Sanjay Deshmukh', '+917233062060', '7255-9749-4311', 'YTIPT6710Z', '374, Koramangala, Sector 11', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b7229f609622', '61a95fa7063f5b6d4939907d862e9c2efc5880f1e244fd401029ae0a7b39ff93', 'e953d98da79c5f07e88fca64ab7b557f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_440af50b4e1c', 'arjun.saxena903@example.in', 'Arjun Saxena', '+919953725126', '8825-4925-3781', 'BWQPL6216Y', '130, Sector 17, Sector 2', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-18T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_440af50b4e1c', 'eb84f04092512bdd712a0b0a726bef7dd472b9b5632deeddea2b1855ffe29fbf', 'e460078b90807c11d3b5d0d8a383e721', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_88526cc8fcba', 'swati.agarwal904@example.in', 'Swati Agarwal', '+918591928218', '5531-4884-6266', 'GIVPS8601J', '935, SG Highway, Sector 4', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-16T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_88526cc8fcba', '1d3a2bc7e3d5c14319520b3da5ea95cb8cf9de9a4c7c895d310f0d8bec69cefa', '4e4c2fea2fdd2b99c8007d0a43882c36', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_028ccdea271c', 'ritika.mukherjee905@example.in', 'Ritika Mukherjee', '+919112691628', '7241-6778-7061', 'BZQPV4538H', '347, Banjara Hills, Sector 14', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-25T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_028ccdea271c', '0d6564443578e4fd67962a25724c9e39147af29abac653a7ea682a9fbb88f2d6', '178e589701a32318a6c91473e1f3313a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9933e45c7a05', 'varun.gupta906@example.in', 'Varun Gupta', '+918208091026', '5058-3777-3245', 'BZZPU0358L', '258, SG Highway, Sector 21', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-24T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9933e45c7a05', '027abc920e080c96096c9b70a1d186fdd89d0959f49e75e801e611eaa84c398a', '4c39f6ca6c72123ab2c3d7c4bb00bfcd', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1700ef66e315', 'varun.pillai907@example.in', 'Varun Pillai', '+918597325065', '6178-4050-7279', 'CJDPE8684H', '320, FC Road, Sector 40', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1700ef66e315', '65e783868b4cc3cc6825cf986c53edde223aa2fad0acc59fdb55fba0de634e04', '2db63379de09d97cc3b694667e4c2492', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_cde4696235e6', 'sneha.malhotra908@example.in', 'Sneha Malhotra', '+919752694772', '2375-9347-9802', 'CPJPD4522Z', '678, MI Road, Sector 6', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-06T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_cde4696235e6', '5427baeb7431aeeb03f0e6393e628e8a904914abd789c92b702ffc93414cdc20', 'ed067b77841a1ed22be4b2584676a36b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7b3325453e81', 'shweta.mehta909@example.in', 'Shweta Mehta', '+919965365758', '7193-5770-7900', 'TXUPN3456E', '178, Park Street, Sector 37', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-27T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7b3325453e81', 'd3dd62b0f8d7cffb354d71d2fe88c0673206423e488d1396b719a3e4285200cf', 'ce7b4e80c6a3af589525a46dc2d29526', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5cf1ea45a5e4', 'simran.kulkarni910@example.in', 'Simran Kulkarni', '+918379975450', '6258-5272-4458', 'PMDPX0770E', '354, FC Road, Sector 28', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-22T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5cf1ea45a5e4', 'e21c9ac2678ba8c3bdaabeb31438ccc6ab262ceedee27af5e52c39ff4af50a4f', 'a3f2d75019116b0a1d4de05d5ef5e9a0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ecbb4e4e7bab', 'aditya.malhotra911@example.in', 'Aditya Malhotra', '+917736979635', '4677-8832-3986', 'HTDPB8330P', '102, FC Road, Sector 16', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-24T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ecbb4e4e7bab', 'a1567931151ab3d9f61028abc64dd5fda669c196c02ae9655a9c9d1de3f01bc5', 'e4b7d3c99fbc87d86e822cdf7202cc7d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a65d359b49f7', 'aditya.kapoor912@example.in', 'Aditya Kapoor', '+919190234172', '4077-9865-5358', 'EGLPR1528G', '240, Banjara Hills, Sector 19', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-20T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a65d359b49f7', 'd8cfe57443a532ff2b96e0081ddb1e5a4751a4ddb1c5c60818d1581604f7f014', '89ace71df3502fe44bb121b13f84f97f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_56b539f6b23b', 'priya.chauhan913@example.in', 'Priya Chauhan', '+918348848782', '6293-4164-4480', 'ZEAPO0233X', '539, SG Highway, Sector 28', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-27T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_56b539f6b23b', 'b866adf1f6c5295d6433559aa46264144b382b90f2607c7b7a1e93527e802556', 'ac6a1e446819d6b466476c43003e8d52', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_19a78422aa9f', 'sneha.kulkarni914@example.in', 'Sneha Kulkarni', '+917652784102', '8668-8146-7026', 'ZEFPG8459A', '78, Connaught Place, Sector 37', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-27T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_19a78422aa9f', 'c4a94d03eb52fbe87ec2410327dde80ec868e5be6e80e30ef4f5cbf15ce1daf6', '430da91faafc50cf2881e7ec2e5e3045', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b4743197e655', 'dev.pandey915@example.in', 'Dev Pandey', '+919670067326', '2839-8866-1371', 'ZXTPR5075H', '797, Banjara Hills, Sector 37', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b4743197e655', '4508ffb7b3c148dd437496ee3b9ea19ce728602bf7da700ec7a9ba5fefd4850a', 'd0f03e6e64f50301bc3539913a0e34b9', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3ecb00d68805', 'deepika.patel916@example.in', 'Deepika Patel', '+917925611378', '3605-6808-1179', 'WUKPZ4025R', '817, M.G. Road, Sector 45', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-29T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3ecb00d68805', '4da3147597507a668939be76b01dac35874ce1537fe8aaeb7f7414d602e87348', '43f449eae4a50185083dec64b7f165e2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_43ab81863ca1', 'kavita.rao917@example.in', 'Kavita Rao', '+918546828866', '7993-6731-6682', 'XDIPL1400C', '478, MI Road, Sector 45', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-08T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_43ab81863ca1', '67c6ac15dd7377a69ded724d51fd8a9982e17b1ff8f3dc0495a12ad6e1771f17', 'b4cee114fb772b12e07900b61c855cb5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_50c85c9b3f44', 'nikhil.kumar918@example.in', 'Nikhil Kumar', '+919776185981', '4126-7434-3743', 'DKAPG3627Y', '533, Indiranagar, Sector 31', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-11T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_50c85c9b3f44', '95aa62fdc83965ff2d702667166448f365c1b0eab64c15fe7b161213a3393765', '4ebbbaefaa2a30e147068e4e1c299371', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bdf082a0cdb9', 'ritika.saxena919@example.in', 'Ritika Saxena', '+918831355240', '8988-2707-2568', 'SGLPH5155U', '69, Koramangala, Sector 1', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-11T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bdf082a0cdb9', '786bdb8664325ff9bcd3900f74e759983149fd27bef8bccdc3c138f8c57f663f', '22b3fd39ce433c85da9309ef66c611e1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_da0d03868f2d', 'aarav.deshmukh920@example.in', 'Aarav Deshmukh', '+917870919935', '9563-5788-9273', 'ZHFPT1027S', '295, Anna Salai, Sector 13', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-02T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_da0d03868f2d', '158f19385de96149323403d35d04cd22a486a17896a9fd5f6032cd160e72de3c', 'a447588dba6f3376eda50fa44a1b782e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f4982165dc1d', 'vikram.kumar921@example.in', 'Vikram Kumar', '+918258518603', '4956-5715-9126', 'ZVXPW7339M', '761, Brigade Road, Sector 40', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-07T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f4982165dc1d', '807532c1cbce643fabd7ca55b1272c63b95dc75190c5ddebedcc3583799b083a', '7139f46557f9ce24febc03ff8e93d8f0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_c0e1b95e593d', 'arjun.dubey922@example.in', 'Arjun Dubey', '+917680280506', '4823-2078-8533', 'NSTPS0586T', '183, Connaught Place, Sector 10', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-26T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_c0e1b95e593d', 'ee258cc83ca5b3206708c8d77ceb8da79bb5b1c1dbec822e692ff23fb456620a', '22e7ae3987e4f506a962c4dcfd990c37', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9f1573efbf06', 'abhishek.menon923@example.in', 'Abhishek Menon', '+918781295350', '5167-9895-5548', 'SXWPR1099T', '666, SG Highway, Sector 3', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9f1573efbf06', '95166f97071e68b1fac867bf16f825f10936399d1187caf5d46ed452e668fa8f', '6bdad14801739a6b35a0172aaf4575a1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d5dd3dad746d', 'vikram.joshi924@example.in', 'Vikram Joshi', '+919154856070', '7403-7887-3716', 'TKMPB8381Z', '801, Banjara Hills, Sector 39', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-17T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d5dd3dad746d', 'c42b404cc50c00f8a58ce5a6c8dd5fe288bb8723e8bda0a2ef61c94e1a0ee9dd', '086eb9cf84739666e04d13853c96cb1d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b2dfa042c453', 'aditya.mukherjee925@example.in', 'Aditya Mukherjee', '+917398134291', '7568-6267-8124', 'LLNPW3273J', '860, Anna Salai, Sector 1', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-21T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b2dfa042c453', '96f0ebd8101a4419c5bf6a7c83e45d643927bd6e362b0c20ae0f199c93b60c91', '19d30bdc7b615f5afe05f3f692beaff2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e6edd41023bd', 'manish.chatterjee926@example.in', 'Manish Chatterjee', '+917200034440', '2998-6575-5493', 'WCFPL6043S', '284, Banjara Hills, Sector 26', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e6edd41023bd', 'f28bfe6e19429004cc0a0d72c3f6ae090d064430a1d110e763a2619825d714a7', '70dcf1e6b0480c1897df8d9e811d58f1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3837a9cd2b0a', 'sunita.menon927@example.in', 'Sunita Menon', '+919395274106', '3443-4693-2891', 'RADPB5688D', '506, SG Highway, Sector 17', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-24T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3837a9cd2b0a', '3bd39efdf10bec31e6cbc8cff47b7ddc0009372e5ead141c17779b865be5c8e1', '2c96fa8eadd4386d3376aee2f1a6b3b3', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3f3f8c19cfa9', 'abhishek.malhotra928@example.in', 'Abhishek Malhotra', '+917178687020', '2099-8600-2277', 'ZIBPJ9765P', '454, SG Highway, Sector 9', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-16T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3f3f8c19cfa9', '500eaff4b10424d780ccae631d3d80a01a49e252d336b5aa5a30a9a876df959e', 'd717f63b5fd3d6e11059a28dbeb70c0a', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2d9fbfd81f3b', 'gaurav.menon929@example.in', 'Gaurav Menon', '+919409172017', '8401-1943-8252', 'THCPE3272G', '66, MI Road, Sector 33', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-26T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2d9fbfd81f3b', '71315c89b70098d80405b5118dffbe708cf55dbed4e6c5134f3790e9effe24be', '1fcd8a1daae8d87cf232278adb81ba7b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_062d404969c7', 'pallavi.chopra930@example.in', 'Pallavi Chopra', '+918392356675', '9833-4807-5161', 'VCSPT4758M', '280, Connaught Place, Sector 8', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-30T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_062d404969c7', '851fd49dbd0ffc6f89c510e6fcffbedd364d8be198e7caae1fc4612c42537a9e', '62ef0b44f900d2918529495d39c90295', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ac79e79485e2', 'meera.saxena931@example.in', 'Meera Saxena', '+917418525820', '3429-9932-8221', 'AUJPJ4564B', '702, FC Road, Sector 17', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-25T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ac79e79485e2', 'fd1b5c8ba208a4432f9653c4c232cfddf76a02230c40050f1dd24ac916bc0188', 'ac74ceca909d02731db2009f6b76dc54', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_19e5a927095b', 'sneha.kulkarni932@example.in', 'Sneha Kulkarni', '+917965282707', '8535-7044-5592', 'WLAPP2729E', '155, Sector 17, Sector 23', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-11T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_19e5a927095b', 'a3cdd5ee73e1f50e34e6f2758dd9cb44f70b7e6bfd8b5b213678c79b4e0a0609', 'c899104523e74210fa991c571c28fa91', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_b64b15908ced', 'rahul.bhatia933@example.in', 'Rahul Bhatia', '+917843449728', '6169-6777-6697', 'WFZPU1391A', '648, FC Road, Sector 5', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-04T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_b64b15908ced', 'a65ac254780bff18b058e6756c23fd58b7905cf19ccf70d03bbb46a39034efb1', '54df94e1cce1edcd393c6fca75447737', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f4e2571a30f0', 'dev.chatterjee934@example.in', 'Dev Chatterjee', '+917548800804', '7357-2644-8968', 'HTUPB0151J', '102, MI Road, Sector 33', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-19T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f4e2571a30f0', '7eb910c00ff80c4085e8c378bd5c997485ef18137341ed2721dbd9b7891a4980', '5bfb53205e1ca8f491f30cd0f32c2d99', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f548eaaa7334', 'ritu.mishra935@example.in', 'Ritu Mishra', '+917414529831', '2208-9180-6635', 'VFAPX5362X', '986, SG Highway, Sector 45', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-15T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f548eaaa7334', 'e52bbdeaf2e9d492982f3b7728108ea30ae01d7dee18b9b56f580d8cb99b7e6a', 'bc5470897723dab9578d68fc78313898', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2fe12cdcd55b', 'aarav.nair936@example.in', 'Aarav Nair', '+918945196146', '2171-2595-4129', 'MTVPG6705U', '351, MI Road, Sector 20', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-19T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2fe12cdcd55b', '7f29de7661e2398be0ba708a3250fd9c0335d4e81f61bcf27f7b18023478619c', '870ebb7abf0e35d63fb568d497f45129', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6735570fea57', 'rohan.bhatia937@example.in', 'Rohan Bhatia', '+918578873150', '8295-3993-5918', 'VOIPX6892K', '802, Banjara Hills, Sector 37', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.173Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6735570fea57', '77215f8fb265a14bac72c9aec2bff19c9f854192244145df20cd0c804b7b61de', '335aed98a14ef39ec22fbdbe13498886', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e35efacf9aed', 'pallavi.chopra938@example.in', 'Pallavi Chopra', '+917772620342', '8626-7494-3364', 'KRJPX8451N', '406, M.G. Road, Sector 12', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-07T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e35efacf9aed', '88be0c5d61971e929783f518b8528ce1f6064b5cb269591aa51d7a9f1ce8cd03', '7da8b5e510e42cf12cf80d74198aff73', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e54b88efbc2f', 'meera.gupta939@example.in', 'Meera Gupta', '+919220829413', '6709-7634-7990', 'TTNPM8052M', '659, M.G. Road, Sector 36', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-06T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e54b88efbc2f', 'be8fa6316ccc45717b1e568f4930b02ebe783c0ac6e25c8c3bb0f21e02163410', 'a7faeae577e23346e20e382d1f283f96', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6e4e8f43b132', 'isha.trivedi940@example.in', 'Isha Trivedi', '+919300964958', '2472-5370-3073', 'FCSPT6036L', '729, Anna Salai, Sector 42', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-26T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6e4e8f43b132', '4611e6763cd3ed2916edbb82c9221561ecb9534ea795ec7ab30f4a66184e797a', 'f5cfc4895762a51ce27e62cfd94a5c3e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_bfcfd5cf811b', 'ananya.trivedi941@example.in', 'Ananya Trivedi', '+917180297271', '5566-9906-1189', 'DIXPE2435J', '268, Park Street, Sector 43', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-09T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_bfcfd5cf811b', '0b738474b2056712e41da212c9aaf11316aa64b9c34bb1e0678fc126494644bc', 'eed960217d53da392c3e6b92008dea90', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_73d1a7cb74be', 'nikhil.joshi942@example.in', 'Nikhil Joshi', '+918553072476', '2014-1719-4741', 'YYTPT6436M', '166, M.G. Road, Sector 7', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_73d1a7cb74be', '1c52f22a146c2c63787ba856a8b41366d6b1452043bd2426ba31b3c80419f027', '127cbaebd4906e667135e1ce77847a71', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1a40194be9ac', 'kunal.kumar943@example.in', 'Kunal Kumar', '+918647995600', '5425-8018-8351', 'KBQPA6653D', '170, Sector 17, Sector 32', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-19T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1a40194be9ac', '6c653ca8d2d32edbd5f90f42dc5deb94b970e0ecb8431b2ce54ec865f6c0186d', '4ad6ed5d2b6733520d939cb5c58e15f8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_ffc8e7031d7b', 'meera.iyer944@example.in', 'Meera Iyer', '+919812538947', '5595-2828-7416', 'TBFPX3603U', '743, Anna Salai, Sector 15', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-30T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_ffc8e7031d7b', '6c88c39f729ae2a178037b4f38caea19ed224b092cd984124153912cad7e8aa1', '11255dbdf03357e437687064e12f0e14', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_520e01d9f907', 'rajesh.malhotra945@example.in', 'Rajesh Malhotra', '+919250841615', '9393-4860-3141', 'YIIPK1640Q', '330, M.G. Road, Sector 38', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-09T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_520e01d9f907', 'b273f521554c7fc4a7ff8785b477e4c3a9ea4565df5eaa94cca5467af53f0ba1', '833ededbd0b11277682d255626f2a434', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d74c5f6cbe22', 'tanvi.sharma946@example.in', 'Tanvi Sharma', '+917897775957', '2348-3505-4388', 'UHKPY6408A', '789, Anna Salai, Sector 38', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-22T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d74c5f6cbe22', '8ec8381e3c0cd297bb143b6b68444793447fc280b7942011c750638d89d9d84d', 'c0612c2b693572b76ab147f3567a09ec', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_42b63133580f', 'rajesh.gupta947@example.in', 'Rajesh Gupta', '+918468377371', '2618-9328-8612', 'YDTPI5054G', '570, SG Highway, Sector 30', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-01T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_42b63133580f', '98f93b976979ec9ebfcf100ccd857e7bd78afccf1acf5130eb98551753642134', '73953c63381640ffdf2800a852a3d3a4', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_43c30ff8277e', 'ritika.patel948@example.in', 'Ritika Patel', '+917691396681', '6982-2421-6606', 'JSFPY8073G', '98, Koramangala, Sector 34', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-12T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_43c30ff8277e', '15a9cb25071f1986cdd63a55b66857c7e057c0f5944f68a90d8b6297753964c4', '96864d82e8445f76fe05184d4c429499', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3939ea2ff9e6', 'ritika.bhattacharya949@example.in', 'Ritika Bhattacharya', '+918573047265', '3835-4218-5199', 'VTIPE2373V', '264, Sector 17, Sector 36', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3939ea2ff9e6', 'e6996d870245e7f1cb3908cd7d7c73fd79e4534ce4aa3d385b44c93c23c99790', 'c2a925e1ac33b8cb660a983b4d63fb75', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_81bc68d38703', 'neha.chopra950@example.in', 'Neha Chopra', '+919399099764', '4339-7483-6732', 'YNMPO4782F', '976, MI Road, Sector 31', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-14T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_81bc68d38703', '3d8d205dc48ef8da3da1e2dfa150bbad1fdbc4fabebc8d5d86d8c4a1713f0435', 'b2af318b9341b5dcf00aa626e2808997', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6ac4c3b15f23', 'alok.mishra951@example.in', 'Alok Mishra', '+918685548550', '9063-9442-4803', 'XAYPH8237F', '772, Anna Salai, Sector 34', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-20T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6ac4c3b15f23', 'fecef0f94a2a645b6d426ec497ecd6f20881c1254e6208877518899d9af14764', '34bfdd938fbb5a5fd8321a3c212b5a40', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5e8f24431455', 'abhishek.pandey952@example.in', 'Abhishek Pandey', '+917831133516', '9784-8252-9811', 'PXCPW6577Y', '60, Anna Salai, Sector 2', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-07T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5e8f24431455', '321dfee1a324483383ffe48e74c3ec1158c0c69a72c2b4acc4cb240762299403', 'ab7841e79fbe86366a40806234b45749', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e028bd081b65', 'amit.pillai953@example.in', 'Amit Pillai', '+919575198271', '5997-2107-8208', 'OVKPR5246G', '987, Indiranagar, Sector 44', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-23T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e028bd081b65', 'd9e9e4b584d02e0a1030cd73da555178400d88f58d44eadbb51c20d65d5d1bd1', 'c5e3e022121886d661724714610f2e4f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1c9522f9fa1b', 'amit.rao954@example.in', 'Amit Rao', '+919354016474', '2327-3264-9324', 'LLKPJ4412R', '879, MI Road, Sector 12', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-07T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1c9522f9fa1b', '41cc28664fbd9152d859b8cb139737c99c087d8070ae66fb34741dc5bb22d7d7', 'df082d99d4f258380993f339f1425c34', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2f4a48a73629', 'bhavna.agarwal955@example.in', 'Bhavna Agarwal', '+917139506544', '9882-6101-4158', 'XWRPE4620T', '937, SG Highway, Sector 6', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-25T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2f4a48a73629', 'b65527f4b562fa87e51bf3633e2a2c0201a9e0af9a1836326b9a6cbe5adb7565', '8f6f0768fc5e6743327f13066b6dc89f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6bef7a5c926e', 'gaurav.verma956@example.in', 'Gaurav Verma', '+918581173079', '6719-8114-1066', 'BCVPH1456J', '173, Koramangala, Sector 40', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6bef7a5c926e', '725c40b3b001a79886ab6f39e7f7dfcd065ab6c45adee1f3938c617bb36c257f', '3aefc5ca2e95eb42013f0924b49a24b5', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1d336ebd91c4', 'karan.kumar957@example.in', 'Karan Kumar', '+917245169323', '2181-5145-9668', 'CUQPL9700C', '953, Brigade Road, Sector 29', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-08T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1d336ebd91c4', '7e569bc53aecf270a0595d40c999ad227b54991af8992465ee492773b3ef17e6', '75ead17a8abdb47709ba169f362db998', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a8e7c1bbd31a', 'ritika.joshi958@example.in', 'Ritika Joshi', '+919110128113', '5923-9394-7571', 'QEIPS6499X', '927, M.G. Road, Sector 27', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-29T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a8e7c1bbd31a', '1e835c35f83f4bab329a98695bb3e1a01ca3ebe23d40c739ae3b3fd708374ae4', '7661a13519fd0cf0351ce4341bd8858b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1257f341191a', 'kavita.mehta959@example.in', 'Kavita Mehta', '+918651364804', '5038-3511-8991', 'NGSPE2560P', '593, Anna Salai, Sector 5', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-10T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1257f341191a', '28ab92963726876b4c3c25f8621921d7a1c949516c8f4b37f2772198a54e9d36', '1d02647cbb0183b6556b7127884f4275', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8b9d6531d343', 'sunita.nair960@example.in', 'Sunita Nair', '+917645316908', '6551-1731-8942', 'JNTPT0298U', '456, Banjara Hills, Sector 21', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-31T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8b9d6531d343', '4b56b033b87c0e0aaf49c0eb3a7202114ef2a06893fac870199b5a6f5a26fa9e', 'c4c10b1ed618adad60eafdacf0554489', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_527185b20fac', 'bhavna.joshi961@example.in', 'Bhavna Joshi', '+918784808397', '3518-5803-7192', 'WUGPE5670W', '909, M.G. Road, Sector 17', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-14T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_527185b20fac', '0aa17efd83f38f448e10aafd9de7650c85df009540f647e81d95212c669df686', 'b5e993c8e8455b14e62400467f30c460', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_6c0ace2a4b8f', 'rohan.gupta962@example.in', 'Rohan Gupta', '+918359954869', '9615-5715-2119', 'GQZPR5538F', '504, FC Road, Sector 37', 'Indore', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-20T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_6c0ace2a4b8f', '99c84f1e36ef9824785c26c480c065432b5fb94f03ac26f77e528b3788187d4d', '65a26f61641fba1db6b704d7d5d8a979', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_48e772b3be63', 'rajesh.kumar963@example.in', 'Rajesh Kumar', '+918566265351', '5367-6708-8658', 'JSTPM5911K', '541, Sector 17, Sector 28', 'Chennai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-02T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_48e772b3be63', 'c31c3989ead8878778bdb17c2ceb8e6b99c0fe4e023849a6e711be90470d2630', '1d801d1e93681dd80857919efea83a5d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f5b1889bfddf', 'vikram.bhattacharya964@example.in', 'Vikram Bhattacharya', '+918335272015', '9593-5717-1376', 'YJWPI7991B', '297, Indiranagar, Sector 15', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-14T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f5b1889bfddf', 'aad0825fd61df2a686a82559216e8183fdacb5c53fd9f64ca0dc4bd0a890e401', 'a8cdfcf35a2c7b478c2ee0ddde95a508', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_8349d6567ee5', 'sneha.deshmukh965@example.in', 'Sneha Deshmukh', '+917743443056', '2134-6738-8880', 'WUPPT8753O', '559, Banjara Hills, Sector 23', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-12T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_8349d6567ee5', '15a787e842f69e7c4d5e6a0fb706bd2b49cf251de68b48a049ed77b6913909e3', '20ab5d2fb23820333814286e16a4881e', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_10c273ebd272', 'arjun.chatterjee966@example.in', 'Arjun Chatterjee', '+919470700421', '9986-5691-8658', 'WZBPO0911J', '808, M.G. Road, Sector 42', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-08T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_10c273ebd272', '7773743ccbe2b523bdb3eaeb1a2a6052b5d5df20a6dd0d3b9c107aa354b15dd8', 'c50e8bee0ef34de98bf9f94092126b38', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_89384f682acf', 'ananya.mehta967@example.in', 'Ananya Mehta', '+919539296584', '9501-8689-1666', 'BQQPE6405Z', '441, Connaught Place, Sector 4', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-19T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_89384f682acf', '44ec40736fcc1a4028bcbf40ab64f83d50da1127d4c0f652ba51d43f805db329', '5fcb817ffc471fbbb5c7752add783640', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_18bc3f730d36', 'rohan.kulkarni968@example.in', 'Rohan Kulkarni', '+919316546477', '9261-8252-7897', 'GKEPN7933Y', '202, MI Road, Sector 10', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-09T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_18bc3f730d36', 'bae5ac1eb167256fadf2af72d80bd1fa7d57a05b727fd586d8f9cad95a7b94b3', '31c811a36e3f503661e9c860f24f673f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e7c70a79b43d', 'aditya.kulkarni969@example.in', 'Aditya Kulkarni', '+917328005871', '3257-2739-6393', 'WPEPU2891A', '367, Sector 17, Sector 17', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-08T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e7c70a79b43d', '50f8520315f5b2fe58eb73b2d824affc109e6fadc2782d5c5a7bb275872f1ce3', 'c1c52175653739d4b57fc4501be93902', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1ee2c19935f7', 'ritu.mukherjee970@example.in', 'Ritu Mukherjee', '+918499514442', '7709-4021-6936', 'VXFPG7350A', '316, Indiranagar, Sector 34', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-08T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1ee2c19935f7', '09f3f345cd511c8e3b0f87c0decc8b6a2a18586c6f4aa5bd58700373936f5afb', '5bce489b173066c2d491d08dcea263b0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_45bc07c2ef93', 'rahul.pillai971@example.in', 'Rahul Pillai', '+917794314300', '7828-3403-3050', 'EGYPG6613A', '62, Connaught Place, Sector 16', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-03T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_45bc07c2ef93', 'b7d97ef344fa86eae5ead56530bb2f7eec366fdc1320eaacff378234dc46c135', '3e3a3814dcdb4dcf44774eb87864beea', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5df827b619b6', 'sunita.nair972@example.in', 'Sunita Nair', '+919802232698', '7947-7991-1357', 'WHVPF1486M', '167, Koramangala, Sector 26', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-21T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5df827b619b6', '4e5b708858e90b5bb3faf89cb9cb4e5dff96d25bef74866d147b9f89354e1880', 'ff4f52ef66b193c7eab6ebc00c739fc0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_7b4b97400ddc', 'pallavi.kulkarni973@example.in', 'Pallavi Kulkarni', '+918120757302', '7016-4938-2799', 'BGNPF7952K', '679, Banjara Hills, Sector 19', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-12T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_7b4b97400ddc', '82b11eb3b33230f9b443d970cb9a03ecae671afe1ac2efb8c649aafb0f076dfa', 'e49c325aa4a99d34f536bde650d5de73', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_11ec90a67f07', 'karan.verma974@example.in', 'Karan Verma', '+919298581078', '3898-2875-7973', 'UEZPT8382W', '96, Park Street, Sector 43', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_11ec90a67f07', 'bbe1b9febf453cbfe7073cbbc912d96ab4b473ad8adc796f9061fe9b83e95126', 'c23f4a04952f43105036ca33e71e8673', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a819518bba21', 'simran.saxena975@example.in', 'Simran Saxena', '+917402182593', '6608-9288-2754', 'BPXPU8857Y', '460, M.G. Road, Sector 18', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-29T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a819518bba21', '4d55e23da4f5537218c2c1483ebc07e531f9ccc0d792e0e218a97e26439b7ae6', '49b7a51e84348412b80964a98e7b8948', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_d5b7e3e41537', 'sneha.deshmukh976@example.in', 'Sneha Deshmukh', '+918308528245', '2602-6346-2186', 'CTJPE0374U', '827, SG Highway, Sector 15', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-19T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_d5b7e3e41537', '3930a5cc0b92c5d8f138cd3f52ff7e148d570f394b682e1cc55462aee97c4173', 'c9369fbb681eabb5e05726e4b0e11104', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_50f3335ce4f2', 'alok.pandey977@example.in', 'Alok Pandey', '+917319121752', '2982-3807-4415', 'RRJPG6038F', '81, Anna Salai, Sector 19', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-28T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_50f3335ce4f2', 'e17a79b509bae51305195504ba43745f4639b8fc6a0318de112a39cde609fb5b', 'fdfbc675e57ff7656401a61a5b2f0d48', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e50afc14b5ac', 'kavita.pillai978@example.in', 'Kavita Pillai', '+919375528334', '4165-9901-5718', 'ZHHPA2061G', '561, Connaught Place, Sector 19', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-12T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e50afc14b5ac', 'adfa82e6b6b9811d21f3ea65298c0de238a75e52f6731d44fa7d988c05e32f74', '441f34aa8805672b78cf758da6ee9dd6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f58965f1305d', 'ritu.pandey979@example.in', 'Ritu Pandey', '+919834032290', '6372-5750-9842', 'FAIPA6941K', '482, Brigade Road, Sector 26', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-13T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f58965f1305d', '834e2e3e21f32c4da3c1d828bb4dbf610f9ce2c058fa2e1f4e3256c22eddfb59', '15c2a1ada09f613b90af3caa57436d1b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_280814069a90', 'divya.agarwal980@example.in', 'Divya Agarwal', '+919206887031', '9790-6008-7547', 'PBEPU2317J', '793, Park Street, Sector 9', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-10T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_280814069a90', '756ba2fc651de06f0a997d0d3c8267e3ddb3ec3a820191c4cf1a95cb4a43aa86', 'b727d0509b673f588354e1208b16b86b', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_53b2b0234a1e', 'amit.dubey981@example.in', 'Amit Dubey', '+919473645161', '3118-7049-6951', 'TVEPO1222Q', '228, Koramangala, Sector 4', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-25T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_53b2b0234a1e', 'b9958dd3bf33b0affa3f05d90c1f424f246149b6aea0310dbbce06161ad25377', 'fd4fc7d41c9dbe71751212b1f7d2a850', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0bd7e1ef9050', 'gaurav.chopra982@example.in', 'Gaurav Chopra', '+919226994301', '5647-5398-3630', 'OTFPR4812K', '362, SG Highway, Sector 11', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-21T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0bd7e1ef9050', '07365cc7ded3e907bf5ad9f43b6874a1504774767d978dbaa47bdd50fc72c9e0', '6226932ad1ba0218373a69c817f14d05', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a3123298a8f0', 'abhishek.pillai983@example.in', 'Abhishek Pillai', '+917792042051', '4388-1077-3585', 'BUXPZ9422X', '141, SG Highway, Sector 5', 'Delhi NCR', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-24T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a3123298a8f0', '9b62d5b13754add9f433df9ebabda6fdb51496f86dc3c86b53145efb5dca2664', '6a9edffbb85c0000a54c4d23ca6d37d1', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_5dd056a596fd', 'arjun.agarwal984@example.in', 'Arjun Agarwal', '+917785715215', '9129-4251-4701', 'OICPH8395Z', '130, Indiranagar, Sector 10', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-22T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_5dd056a596fd', '67f415c38916f8daa34a8223139e358cf1d16cd768389a2b9a50dcbaf83f818c', 'e22375fb15d3965970e83379677ef60f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_648440c23500', 'alok.bhatia985@example.in', 'Alok Bhatia', '+919574582468', '6397-4382-6693', 'GKTPV4435J', '421, Koramangala, Sector 19', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-14T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_648440c23500', '7288265560f0b75f4a88a8ac4063620283018d46182b9957eb3e9b933e940a63', '5952cc6f92bd7f9e88ffdff39bf79142', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_4058dbb0d066', 'nikhil.trivedi986@example.in', 'Nikhil Trivedi', '+919827252103', '2417-4589-6492', 'NAUPD7186V', '410, Brigade Road, Sector 27', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-04-03T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_4058dbb0d066', '36d60366eadfe65292194fa62c7b03e6853c6f9495d25817b4ae6589b5c64e9b', 'd52a4ba832ed15bf71b9de321a353058', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_1ead53bd2912', 'shweta.bose987@example.in', 'Shweta Bose', '+917478054237', '5042-7838-4257', 'FQCPG0977P', '825, Indiranagar, Sector 1', 'Bengaluru', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-01T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_1ead53bd2912', 'd75b0119817375081206ace1d2d7fb96c02668273135c3b3762177da2407dda6', 'ffed746e7840105bb76094ec7358b552', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_290dcd2346da', 'arjun.kapoor988@example.in', 'Arjun Kapoor', '+919136235923', '3900-2578-9362', 'KLKPJ3090I', '862, Banjara Hills, Sector 15', 'Jaipur', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-03T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_290dcd2346da', '98364f6f6e966e387c3cb1db0ac93ad13f9ec4ae65327d31c9be4a84da66e83a', '7c6ceee2de27eb1f0150b45bbb4dcee8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9860db108818', 'ananya.sharma989@example.in', 'Ananya Sharma', '+919652358172', '8884-5048-5297', 'GTPPA9308G', '591, Park Street, Sector 6', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-05T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9860db108818', '9931690adabd83d852306bd791b6c7612100352655c0b628a53d0762812ec449', 'a470a0743fe3ccbc748ec367ce9eb02f', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_3d602262f5db', 'ritika.agarwal990@example.in', 'Ritika Agarwal', '+918347603869', '6217-9707-1052', 'SONPL4891Y', '993, SG Highway, Sector 3', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-28T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_3d602262f5db', '24094cb941ddb212aa6e4671e828935e3b1f83a3c2bb4c59ab1c03500c314f78', '09bfaf2664472cbd2eb0919aa7383436', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_78f31319ed83', 'simran.singh991@example.in', 'Simran Singh', '+917832096494', '6456-7354-3705', 'SSQPP3534K', '834, Koramangala, Sector 8', 'Lucknow', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-15T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_78f31319ed83', 'af89c62c5397503e970cd2596fb90fa4089976c51f2e8f669c3f555c0c2c8abd', 'b071e238450a3159a7bb88767c6052ac', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_f2342b9d96b5', 'arjun.rao992@example.in', 'Arjun Rao', '+918828989103', '7581-1033-5106', 'QQDPT3608F', '382, Brigade Road, Sector 41', 'Hyderabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-09-06T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_f2342b9d96b5', '4cee32f3d479e415cb68c3acc0839d00bf6027e62c1a5f1424f1c6fff0e6ef6a', '78a4efa7a421b6eb64c9f89ad3269fc2', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_0f0509b982bd', 'alok.deshmukh993@example.in', 'Alok Deshmukh', '+919840775080', '4700-9212-8305', 'RNPPD4533W', '520, Brigade Road, Sector 6', 'Kolkata', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-20T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_0f0509b982bd', '789cfc9214ee256b449a01fcc212296247e714391a8405e9f765e08c4e1ef667', 'dae119c85f4cff65ceb19ca9143e6080', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_9e733361ff31', 'rahul.pillai994@example.in', 'Rahul Pillai', '+917987328316', '7393-6922-7671', 'XEYPI0992F', '608, Park Street, Sector 31', 'Chandigarh', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-15T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_9e733361ff31', 'f1663a9ef3b15d48433f9e3c0d22da6a0fc36490ce21ea9dc23f00286b790f1b', '84107f54e76bf199a3af61abbd2c37a8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_37f9059154d2', 'sneha.chatterjee995@example.in', 'Sneha Chatterjee', '+918689334394', '4173-2014-6899', 'RYTPQ3059O', '309, Brigade Road, Sector 41', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-06-16T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_37f9059154d2', '74701ac07d80cee9840d14b74b7ecbf5bd9ac143c8a4394573154dffb7051ed1', '643797a6e70b2019d1789692bfa3eee0', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_456c8cb29491', 'arjun.nair996@example.in', 'Arjun Nair', '+919142839454', '2760-1319-6013', 'LNMPV7346M', '982, Banjara Hills, Sector 16', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-08-30T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_456c8cb29491', 'c06bbfb1543bb7bbced4a5a2c139cc94b5abd7198a12b64784774eb8bb3e3d6e', '15d27a7074d81403e1da4512d80fba2d', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_a01c1193bce3', 'divya.kapoor997@example.in', 'Divya Kapoor', '+918252412991', '2653-9992-3672', 'KMZPT7594A', '133, Connaught Place, Sector 13', 'Kochi', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-07-24T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_a01c1193bce3', '784be0d333ad1c76ce3363cecde0154c99b7a59831cb8076fc88b331850c241a', '2b08184c847890e62606ff337a89e4e6', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_2cca156be97e', 'dev.deshmukh998@example.in', 'Dev Deshmukh', '+918936703208', '3850-6702-2038', 'DRSPA3398I', '164, Connaught Place, Sector 27', 'Ahmedabad', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-11T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_2cca156be97e', '298151eee95e46d947b12901e1faa0150181fb9b12b56f8c8c266d65dd21763b', '8bf78aff0b159eaea760d4b729c745e8', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_626a5d76192d', 'tanvi.saxena999@example.in', 'Tanvi Saxena', '+919837154889', '7293-9931-6654', 'YNYPG5388S', '212, Banjara Hills, Sector 14', 'Mumbai', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-05-17T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_626a5d76192d', '445f980c7c88fa7d9089e2f81dcafdb24e00dbd396692dabf72a27ddb9825c02', '5eb3c375c4d338ac0759e85c3b926dff', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO users (id, email, full_name, phone, aadhaar_no, pan_no, street_address, city, consent_purposes, created_at)
VALUES ('usr_e86f7af5d37b', 'pooja.trivedi1000@example.in', 'Pooja Trivedi', '+917263745200', '8135-4907-3818', 'NAMPU4614Y', '691, Anna Salai, Sector 18', 'Pune', '["ORDER_FULFILLMENT","MARKETING_SMS","CUSTOMER_ANALYTICS"]', '2026-03-29T10:59:26.174Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, phone = EXCLUDED.phone;

INSERT INTO customer_credentials (user_id, password_hash, salt, updated_at)
VALUES ('usr_e86f7af5d37b', 'c03605143ecaa919271fd20eeb5ce7b8df0145bd643cf0456cba90629c35e72c', 'a8308e2364daee3e5baa5aa416f13ede', NOW())
ON CONFLICT (user_id) DO UPDATE SET password_hash = EXCLUDED.password_hash, salt = EXCLUDED.salt;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_061ece2512', 'Nikhil Kumar', 'emp.nikhil.kumar1@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 118031, 'RHAPI6615B', '2025-05-25T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_a4d8925d86', 'Sneha Iyer', 'emp.sneha.iyer2@enterprise-corp.in', 'Human Resources', 'Payroll Lead', 81954, 'OWBPW6236M', '2024-12-06T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_0ecb30049d', 'Abhishek Reddy', 'emp.abhishek.reddy3@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 63346, 'MBDPL2969C', '2025-03-16T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_ab010daa74', 'Neha Nair', 'emp.neha.nair4@enterprise-corp.in', 'Finance & Accounts', 'Staff Accountant', 241338, 'CITPA4448O', '2026-04-14T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_be7b12420c', 'Rahul Agarwal', 'emp.rahul.agarwal5@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 48569, 'UPBPG3176E', '2026-06-08T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_51e2c1c0a8', 'Karan Chauhan', 'emp.karan.chauhan6@enterprise-corp.in', 'Legal & Compliance', 'Legal Counsel', 92887, 'BQJPS7765R', '2025-06-24T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_a76f8794cc', 'Dev Dubey', 'emp.dev.dubey7@enterprise-corp.in', 'Customer Support', 'Escalations Manager', 217345, 'STYPD2902L', '2025-02-22T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_3a9e6ca917', 'Manish Kapoor', 'emp.manish.kapoor8@enterprise-corp.in', 'Marketing & Sales', 'Account Executive', 174601, 'DQCPV3970K', '2025-11-11T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_37e71dc416', 'Aarav Kapoor', 'emp.aarav.kapoor9@enterprise-corp.in', 'Customer Support', 'Customer Success Lead', 165832, 'VKDPA0721T', '2025-06-01T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_7bc26d69f5', 'Nikhil Kumar', 'emp.nikhil.kumar10@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 158245, 'GINPZ7106E', '2025-10-05T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_4a9bdfc10d', 'Vikram Gupta', 'emp.vikram.gupta11@enterprise-corp.in', 'Customer Support', 'Customer Success Lead', 245183, 'WUMPT4092P', '2025-09-27T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_467de711d7', 'Neha Bhattacharya', 'emp.neha.bhattacharya12@enterprise-corp.in', 'Human Resources', 'HR Manager', 80781, 'DBPPJ5481P', '2026-04-22T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_8aeabaa384', 'Tanvi Bhatia', 'emp.tanvi.bhatia13@enterprise-corp.in', 'Human Resources', 'Payroll Lead', 99623, 'KIFPI4080V', '2024-10-08T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_6f041ce38c', 'Gaurav Deshmukh', 'emp.gaurav.deshmukh14@enterprise-corp.in', 'Engineering', 'Senior DevOps', 95499, 'HEIPU7039R', '2026-04-14T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_386492948c', 'Pallavi Sharma', 'emp.pallavi.sharma15@enterprise-corp.in', 'Customer Support', 'Customer Success Lead', 87272, 'NMNPJ2778O', '2026-03-07T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_279f1501fd', 'Harsh Verma', 'emp.harsh.verma16@enterprise-corp.in', 'Finance & Accounts', 'Staff Accountant', 139901, 'JQLPW4849Z', '2024-10-16T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_97da5453dc', 'Swati Kumar', 'emp.swati.kumar17@enterprise-corp.in', 'Human Resources', 'Payroll Lead', 90886, 'QDQPL7923R', '2025-12-13T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_643ac53e5c', 'Pooja Verma', 'emp.pooja.verma18@enterprise-corp.in', 'Customer Support', 'Escalations Manager', 136569, 'KZEPM7520O', '2024-11-21T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f607ccf27f', 'Sneha Dubey', 'emp.sneha.dubey19@enterprise-corp.in', 'Marketing & Sales', 'Growth Marketing Manager', 130171, 'KFQPM8512T', '2026-05-14T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_af4514127b', 'Abhishek Mukherjee', 'emp.abhishek.mukherjee20@enterprise-corp.in', 'Engineering', 'Software Engineer', 228308, 'PPZPF3525I', '2025-07-01T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_5e577e5fc2', 'Sanjay Pandey', 'emp.sanjay.pandey21@enterprise-corp.in', 'Human Resources', 'Payroll Lead', 200374, 'WOYPZ4369Y', '2025-09-18T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_3d0540395b', 'Aditya Joshi', 'emp.aditya.joshi22@enterprise-corp.in', 'Engineering', 'QA Lead', 135775, 'HYNPS5689J', '2025-02-14T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_dfe5cea32f', 'Abhishek Mukherjee', 'emp.abhishek.mukherjee23@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 203117, 'RIGPS9491L', '2026-07-30T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_70d9c096e8', 'Simran Iyer', 'emp.simran.iyer24@enterprise-corp.in', 'Engineering', 'Principal Architect', 120015, 'SWEPS3938Z', '2024-10-25T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_73e05a196f', 'Alok Trivedi', 'emp.alok.trivedi25@enterprise-corp.in', 'Human Resources', 'HR Manager', 53471, 'SWDPX5605E', '2026-06-24T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_1f35992880', 'Ananya Sharma', 'emp.ananya.sharma26@enterprise-corp.in', 'Human Resources', 'HR Manager', 230419, 'HXJPM1489U', '2025-12-11T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_cb790812ef', 'Aditya Mukherjee', 'emp.aditya.mukherjee27@enterprise-corp.in', 'Marketing & Sales', 'Growth Marketing Manager', 197978, 'OJKPN0767H', '2026-05-24T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_6f37a5d8fb', 'Isha Chatterjee', 'emp.isha.chatterjee28@enterprise-corp.in', 'Customer Support', 'Escalations Manager', 242053, 'IJLPZ1683N', '2024-12-08T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_984b02034c', 'Alok Pillai', 'emp.alok.pillai29@enterprise-corp.in', 'Human Resources', 'Payroll Lead', 68354, 'RJVPC2695H', '2025-10-06T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f98971389f', 'Kunal Bhatia', 'emp.kunal.bhatia30@enterprise-corp.in', 'Finance & Accounts', 'Tax Consultant', 185101, 'VFFPN9834Q', '2026-04-22T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_7fe95587ff', 'Ritu Kulkarni', 'emp.ritu.kulkarni31@enterprise-corp.in', 'Marketing & Sales', 'Growth Marketing Manager', 198175, 'GCGPE0903Z', '2025-08-26T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_78665b0223', 'Deepika Bhattacharya', 'emp.deepika.bhattacharya32@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 180185, 'TBTPB9787K', '2026-02-08T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_b6e3464077', 'Arjun Iyer', 'emp.arjun.iyer33@enterprise-corp.in', 'Customer Support', 'Customer Success Lead', 53069, 'YQVPI1714A', '2025-04-14T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_bba3d07169', 'Vikram Pillai', 'emp.vikram.pillai34@enterprise-corp.in', 'Marketing & Sales', 'Growth Marketing Manager', 149418, 'WEJPK5585Y', '2025-07-27T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_b366ef5721', 'Swati Trivedi', 'emp.swati.trivedi35@enterprise-corp.in', 'Engineering', 'Senior DevOps', 104690, 'UQTPA3654Y', '2025-10-02T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_8912ba4da1', 'Bhavna Kapoor', 'emp.bhavna.kapoor36@enterprise-corp.in', 'Legal & Compliance', 'Compliance Officer', 175191, 'QMJPV8727R', '2025-10-13T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_694be5f363', 'Aditya Pandey', 'emp.aditya.pandey37@enterprise-corp.in', 'Finance & Accounts', 'Staff Accountant', 67351, 'EOMPO4496X', '2025-03-07T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_e74a50bd18', 'Arjun Rao', 'emp.arjun.rao38@enterprise-corp.in', 'Engineering', 'Software Engineer', 131585, 'HBNPF1917A', '2025-07-31T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_0cfd63410f', 'Varun Singh', 'emp.varun.singh39@enterprise-corp.in', 'Finance & Accounts', 'Staff Accountant', 100680, 'PVSPF5539N', '2025-08-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_21372e66ea', 'Ananya Malhotra', 'emp.ananya.malhotra40@enterprise-corp.in', 'Human Resources', 'Payroll Lead', 186891, 'ZXVPM8712T', '2025-10-20T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_9e3505f29b', 'Anjali Kumar', 'emp.anjali.kumar41@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 135857, 'TUCPL3645N', '2025-01-06T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_5fb13e1bd0', 'Anjali Bhatia', 'emp.anjali.bhatia42@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 128303, 'DNMPB1125G', '2024-10-04T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_5ca37ff0ff', 'Simran Kulkarni', 'emp.simran.kulkarni43@enterprise-corp.in', 'Customer Support', 'Customer Support Executive', 220696, 'VBMPZ5790O', '2025-01-20T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_9cc8ab7a3c', 'Harsh Joshi', 'emp.harsh.joshi44@enterprise-corp.in', 'Engineering', 'Software Engineer', 112192, 'BRJPD0269T', '2025-10-16T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_613adf43e6', 'Deepika Saxena', 'emp.deepika.saxena45@enterprise-corp.in', 'Human Resources', 'Payroll Lead', 160276, 'BKMPM2805A', '2025-05-20T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_cd5461d842', 'Meera Agarwal', 'emp.meera.agarwal46@enterprise-corp.in', 'Finance & Accounts', 'Tax Consultant', 244353, 'FZVPB3466O', '2025-03-29T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_125e997e22', 'Rohan Sharma', 'emp.rohan.sharma47@enterprise-corp.in', 'Engineering', 'Principal Architect', 121571, 'HRAPB9780R', '2025-09-16T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_b591261559', 'Neha Trivedi', 'emp.neha.trivedi48@enterprise-corp.in', 'Customer Support', 'Escalations Manager', 238841, 'JQSPT2532U', '2024-09-23T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_0c802f5d11', 'Bhavna Trivedi', 'emp.bhavna.trivedi49@enterprise-corp.in', 'Marketing & Sales', 'Account Executive', 92013, 'WSBPC7036V', '2025-05-28T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_2a32e41b61', 'Karan Sharma', 'emp.karan.sharma50@enterprise-corp.in', 'Legal & Compliance', 'Legal Counsel', 202223, 'JOOPO0260B', '2025-05-24T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f5141195a0', 'Shweta Mehta', 'emp.shweta.mehta51@enterprise-corp.in', 'Legal & Compliance', 'Legal Counsel', 70423, 'RFEPG4519N', '2024-10-07T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_1533d7306d', 'Aarav Bhatia', 'emp.aarav.bhatia52@enterprise-corp.in', 'Marketing & Sales', 'Account Executive', 153465, 'IEBPX2148J', '2025-10-18T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_1a49aab21e', 'Manish Sharma', 'emp.manish.sharma53@enterprise-corp.in', 'Engineering', 'Software Engineer', 93830, 'VYPPX0648V', '2025-03-16T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_ef52a7a083', 'Arjun Agarwal', 'emp.arjun.agarwal54@enterprise-corp.in', 'Finance & Accounts', 'Tax Consultant', 200934, 'DZZPO6265E', '2025-05-21T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_13f46b6e26', 'Pallavi Bhattacharya', 'emp.pallavi.bhattacharya55@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 199296, 'CPCPW1202Y', '2024-11-04T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_8aa13e1569', 'Sneha Pandey', 'emp.sneha.pandey56@enterprise-corp.in', 'Human Resources', 'Talent Acquisition Specialist', 152944, 'YQTPZ1897A', '2026-04-20T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_6d6a6a0781', 'Ritika Sharma', 'emp.ritika.sharma57@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 195617, 'PKQPS9735I', '2025-01-29T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_cf527e05b6', 'Kavita Joshi', 'emp.kavita.joshi58@enterprise-corp.in', 'Customer Support', 'Customer Support Executive', 116987, 'UOTPW9087A', '2025-02-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_eb637c7ebd', 'Harsh Kumar', 'emp.harsh.kumar59@enterprise-corp.in', 'Engineering', 'Software Engineer', 123307, 'UBPPE8927A', '2024-12-02T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_2097d1fe87', 'Anjali Saxena', 'emp.anjali.saxena60@enterprise-corp.in', 'Marketing & Sales', 'Account Executive', 129467, 'OCHPU4914Z', '2025-06-21T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_59c31394f2', 'Pallavi Patel', 'emp.pallavi.patel61@enterprise-corp.in', 'Marketing & Sales', 'Product Marketing Lead', 81472, 'WICPS0552U', '2025-06-27T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_a1942283e1', 'Karan Bhattacharya', 'emp.karan.bhattacharya62@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 239634, 'QONPB7458C', '2025-09-29T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_38c57b1291', 'Rahul Bhatia', 'emp.rahul.bhatia63@enterprise-corp.in', 'Engineering', 'Software Engineer', 247088, 'ZKYPR8910R', '2024-11-19T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_35e016ad40', 'Aarav Chauhan', 'emp.aarav.chauhan64@enterprise-corp.in', 'Engineering', 'Software Engineer', 216122, 'BCVPC5390B', '2026-01-03T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_3fe5a73cab', 'Meera Agarwal', 'emp.meera.agarwal65@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 76780, 'ORZPN9047T', '2025-12-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_660ab5db0c', 'Kavita Bhattacharya', 'emp.kavita.bhattacharya66@enterprise-corp.in', 'Human Resources', 'HR Manager', 180439, 'HYXPL7434B', '2025-12-28T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_b40c93eee9', 'Swati Dubey', 'emp.swati.dubey67@enterprise-corp.in', 'Legal & Compliance', 'Compliance Officer', 49260, 'EBGPS0651U', '2025-07-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_322a40efbd', 'Divya Trivedi', 'emp.divya.trivedi68@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 148598, 'UZDPL9686C', '2026-07-30T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_b572ddbdd2', 'Rahul Chauhan', 'emp.rahul.chauhan69@enterprise-corp.in', 'Engineering', 'QA Lead', 163705, 'IASPI3394B', '2024-10-06T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_e17268e331', 'Deepika Saxena', 'emp.deepika.saxena70@enterprise-corp.in', 'Legal & Compliance', 'Compliance Officer', 85996, 'BGFPS7219J', '2025-08-06T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_dc8d9e5c6d', 'Simran Pillai', 'emp.simran.pillai71@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 240951, 'QUQPZ1155L', '2025-03-07T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_d0218c0ceb', 'Sunita Chopra', 'emp.sunita.chopra72@enterprise-corp.in', 'Legal & Compliance', 'Legal Counsel', 172405, 'RUJPQ0040V', '2025-08-01T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_ed34561d9f', 'Aditya Nair', 'emp.aditya.nair73@enterprise-corp.in', 'Legal & Compliance', 'Compliance Officer', 140735, 'IFLPK2537Q', '2025-01-08T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_5b03eadd5e', 'Divya Joshi', 'emp.divya.joshi74@enterprise-corp.in', 'Engineering', 'QA Lead', 165464, 'FMSPK1380B', '2025-02-21T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_c08231fde5', 'Ritika Mehta', 'emp.ritika.mehta75@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 53283, 'IXZPE2583S', '2025-12-11T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_86d5fdebcd', 'Meera Bose', 'emp.meera.bose76@enterprise-corp.in', 'Customer Support', 'Customer Support Executive', 87250, 'AYSPP9157Q', '2025-12-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_48dd2ef875', 'Priya Deshmukh', 'emp.priya.deshmukh77@enterprise-corp.in', 'Legal & Compliance', 'Legal Counsel', 135070, 'UDDPU4129V', '2026-01-21T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_eba10eeea1', 'Kavita Kulkarni', 'emp.kavita.kulkarni78@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 153745, 'BYJPM8021W', '2025-10-21T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_170bbd4fe2', 'Sneha Patel', 'emp.sneha.patel79@enterprise-corp.in', 'Customer Support', 'Customer Success Lead', 141346, 'GVKPU0842D', '2025-01-31T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_ae3fa55b7e', 'Neha Malhotra', 'emp.neha.malhotra80@enterprise-corp.in', 'Legal & Compliance', 'Legal Counsel', 215143, 'OMOPF3674W', '2026-01-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_cf595fcf81', 'Neha Bose', 'emp.neha.bose81@enterprise-corp.in', 'Marketing & Sales', 'Account Executive', 246519, 'PFNPI4014T', '2025-01-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_3542d88853', 'Simran Pandey', 'emp.simran.pandey82@enterprise-corp.in', 'Engineering', 'QA Lead', 70076, 'LGQPD9201J', '2025-03-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_5fc8fa2a61', 'Harsh Pandey', 'emp.harsh.pandey83@enterprise-corp.in', 'Legal & Compliance', 'Legal Counsel', 73559, 'GDYPH0521A', '2024-10-07T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_a43b6350b9', 'Manish Kulkarni', 'emp.manish.kulkarni84@enterprise-corp.in', 'Engineering', 'Senior DevOps', 216435, 'EYSPH3032O', '2026-05-17T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f0104c4442', 'Sanjay Trivedi', 'emp.sanjay.trivedi85@enterprise-corp.in', 'Marketing & Sales', 'Product Marketing Lead', 182041, 'QSBPG8038B', '2024-10-29T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_035b46b3e9', 'Tanvi Gupta', 'emp.tanvi.gupta86@enterprise-corp.in', 'Marketing & Sales', 'Product Marketing Lead', 188278, 'NZNPW8219E', '2025-03-26T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_1c6aef8f90', 'Amit Rao', 'emp.amit.rao87@enterprise-corp.in', 'Legal & Compliance', 'Compliance Officer', 204376, 'FMKPM0197B', '2025-08-19T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_a9aed3a70e', 'Ritika Trivedi', 'emp.ritika.trivedi88@enterprise-corp.in', 'Engineering', 'Software Engineer', 198667, 'KMSPE3049A', '2025-09-08T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_3a8a77a9ca', 'Nikhil Bose', 'emp.nikhil.bose89@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 238052, 'SORPC3406W', '2025-12-26T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_28339217ad', 'Dev Singh', 'emp.dev.singh90@enterprise-corp.in', 'Human Resources', 'Talent Acquisition Specialist', 172978, 'UZZPM0265O', '2025-06-21T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_175ff30b97', 'Simran Reddy', 'emp.simran.reddy91@enterprise-corp.in', 'Marketing & Sales', 'Product Marketing Lead', 78124, 'JDFPQ0531M', '2025-12-07T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f900462cd9', 'Arjun Kumar', 'emp.arjun.kumar92@enterprise-corp.in', 'Finance & Accounts', 'Senior Financial Analyst', 199051, 'AUKPG2874G', '2025-01-23T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f96fe87023', 'Sunita Kulkarni', 'emp.sunita.kulkarni93@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 199010, 'VCFPQ5916Q', '2025-01-19T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_d1db6fff8d', 'Alok Malhotra', 'emp.alok.malhotra94@enterprise-corp.in', 'Human Resources', 'Talent Acquisition Specialist', 135557, 'JDJPW3910A', '2025-10-17T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_711af72636', 'Arjun Malhotra', 'emp.arjun.malhotra95@enterprise-corp.in', 'Human Resources', 'Talent Acquisition Specialist', 122131, 'GERPL4107Y', '2025-04-26T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f4e01767af', 'Sanjay Mishra', 'emp.sanjay.mishra96@enterprise-corp.in', 'Legal & Compliance', 'Compliance Officer', 241881, 'NHZPM2333G', '2024-10-02T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_f20e414d83', 'Ritu Patel', 'emp.ritu.patel97@enterprise-corp.in', 'Engineering', 'Software Engineer', 132585, 'TLBPZ2914A', '2026-01-09T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_38ccfe290f', 'Deepika Gupta', 'emp.deepika.gupta98@enterprise-corp.in', 'Customer Support', 'Escalations Manager', 137922, 'WXPPG4055S', '2025-04-01T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_0b0f6996f7', 'Sunita Kumar', 'emp.sunita.kumar99@enterprise-corp.in', 'Legal & Compliance', 'Data Protection Officer', 125756, 'CKNPW8094X', '2024-10-14T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;


INSERT INTO employees (id, full_name, email, department, role, salary, pan_no, created_at)
VALUES ('emp_172ce61450', 'Siddharth Mehta', 'emp.siddharth.mehta100@enterprise-corp.in', 'Customer Support', 'Customer Success Lead', 84693, 'BFGPQ1196U', '2025-01-30T10:59:26.177Z')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name, salary = EXCLUDED.salary;

COMMIT;
