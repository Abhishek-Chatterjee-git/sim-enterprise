/**
 * Domain types for Simulated Enterprise E-Commerce & Privacy Platform
 * Represents enterprise production schema and customer interactions
 */

export type UserStatus = 'ACTIVE' | 'SOFT_DELETED' | 'QUARANTINED' | 'SUSPENDED' | 'PENDING_VERIFICATION';

export interface User {
  id: string;
  full_name: string;
  email: string;
  phone: string;
  password_hash: string;
  aadhaar_no: string;
  pan_no: string;
  address: string;
  city: string;
  state: string;
  pincode: string;
  status: UserStatus;
  created_at: string;
  updated_at: string;
}

export type OrderStatus = 'CONFIRMED' | 'PROCESSING' | 'SHIPPED' | 'DELIVERED' | 'CANCELLED';

export interface Order {
  id: string;
  user_id: string;
  order_number: string;
  total_amount: number;
  currency: string;
  status: OrderStatus;
  shipping_address: string;
  payment_method: string;
  created_at: string;
  updated_at: string;
  items?: OrderItem[];
}

export interface OrderItem {
  id: string;
  order_id: string;
  product_name: string;
  sku: string;
  quantity: number;
  unit_price: number;
  total_price: number;
}

export type PaymentStatus = 'SUCCESS' | 'PENDING' | 'FAILED' | 'REFUNDED';

export interface Payment {
  id: string;
  order_id: string;
  user_id: string;
  transaction_id: string;
  payment_gateway: string;
  amount: number;
  currency: string;
  status: PaymentStatus;
  upi_id?: string;
  card_last_four?: string;
  created_at: string;
}

export interface CustomerReview {
  id: string;
  user_id: string;
  product_name: string;
  rating: number;
  review_text: string;
  created_at: string;
}

export interface AuditLog {
  id: string;
  action: string;
  user_id: string;
  ip_address: string;
  user_agent: string;
  details: string;
  created_at: string;
}

export interface Product {
  id: string;
  name: string;
  sku: string;
  category: string;
  price: number;
  rating: number;
  image: string;
  stock: number;
  description: string;
}

export interface ConsentPreference {
  id: string;
  user_id: string;
  purpose_id: string;
  is_granted: boolean;
  notice_version: string;
  updated_at: string;
}

export interface ConsentNoticeDetail {
  version: string;
  title: string;
  statutoryBasis: string;
  purposes: {
    purposeId: string;
    name: string;
    description: string;
    isMandatory: boolean;
    dataCategories: string[];
    retentionDays: number;
  }[];
}
