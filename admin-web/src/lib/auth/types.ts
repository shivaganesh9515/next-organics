// Auth Types for Nextgen Organics

export type UserRole = 'ADMIN' | 'VENDOR' | 'CUSTOMER';

export type VendorStatus = 'PENDING' | 'APPROVED' | 'REJECTED';

export interface AuthUser {
  id: string;
  email: string;
  name?: string;
  phone?: string;
  role: UserRole;
  vendorStatus?: VendorStatus;
}

export interface AuthResult {
  success: boolean;
  error?: string;
  errorCode?: 'INVALID_CREDENTIALS' | 'WRONG_ROLE' | 'VENDOR_PENDING' | 'VENDOR_REJECTED' | 'UNKNOWN';
  user?: AuthUser;
}
