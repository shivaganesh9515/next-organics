// Auth Constants for Nextgen Organics

// Route definitions
export const ADMIN_ROUTES = [
    '/admin',
    '/banners',
    '/manufacturers',
    '/users',
    '/settings',
] as const;

export const VENDOR_ROUTES = [
    '/vendor',
    '/inventory',
    '/orders',
    '/earnings',
] as const;

export const PUBLIC_ROUTES = [
    '/admin/login',
    '/vendor/login',
    '/auth/callback',
] as const;

// Login redirect paths
export const ADMIN_LOGIN_PATH = '/admin/login';
export const VENDOR_LOGIN_PATH = '/vendor/login';
export const ADMIN_DASHBOARD_PATH = '/admin/dashboard';
export const VENDOR_DASHBOARD_PATH = '/vendor/dashboard';
export const VENDOR_PENDING_PATH = '/vendor/pending';

// Error messages
export const AUTH_ERRORS = {
    INVALID_CREDENTIALS: 'Invalid email or password. Please try again.',
    WRONG_ROLE_ADMIN: 'This account is not an admin. Please use the Vendor Portal.',
    WRONG_ROLE_VENDOR: 'This account is not a vendor. Please use the Admin Portal.',
    VENDOR_PENDING: 'Your vendor account is pending approval.',
    VENDOR_REJECTED: 'Your vendor application has been rejected.',
    SESSION_EXPIRED: 'Your session has expired. Please log in again.',
    UNKNOWN: 'An unexpected error occurred. Please try again.',
} as const;
