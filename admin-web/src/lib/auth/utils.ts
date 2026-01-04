import { createClient } from '@/utils/supabase/server';
import type { AuthUser, UserRole, VendorStatus } from './types';

/**
 * Get the current authenticated user with their role and vendor status
 */
export async function getUserWithRole(): Promise<AuthUser | null> {
    const supabase = await createClient();

    const { data: { user } } = await supabase.auth.getUser();

    if (!user) return null;

    // Fetch profile with role info
    const { data: profile } = await supabase
        .from('profiles')
        .select('role, vendor_status, full_name, phone')
        .eq('id', user.id)
        .single();

    if (!profile) {
        // User exists but no profile - treat as customer
        return {
            id: user.id,
            email: user.email || '',
            role: 'CUSTOMER',
        };
    }

    return {
        id: user.id,
        email: user.email || '',
        name: profile.full_name || undefined,
        phone: profile.phone || undefined,
        role: (profile.role?.toUpperCase() || 'CUSTOMER') as UserRole,
        vendorStatus: profile.vendor_status?.toUpperCase() as VendorStatus | undefined,
    };
}

/**
 * Check if user is an admin
 */
export function isAdmin(user: AuthUser | null): boolean {
    return user?.role === 'ADMIN';
}

/**
 * Check if user is a vendor
 */
export function isVendor(user: AuthUser | null): boolean {
    return user?.role === 'VENDOR';
}

/**
 * Check if vendor is approved
 */
export function isVendorApproved(user: AuthUser | null): boolean {
    return user?.role === 'VENDOR' && user?.vendorStatus === 'APPROVED';
}

/**
 * Check if vendor is pending approval
 */
export function isVendorPending(user: AuthUser | null): boolean {
    return user?.role === 'VENDOR' && user?.vendorStatus === 'PENDING';
}

/**
 * Sign out the current user
 */
export async function signOut(): Promise<void> {
    const supabase = await createClient();
    await supabase.auth.signOut();
}
