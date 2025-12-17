# 🚀 NextGen Organics - Supabase Setup Guide

Follow these 4 simple steps to set up your Database, Vendors, Products, and Logins.

---

## 🛠️ Step 1: Run the Database Schema

This prepares the empty tables (Profiles, Banners, Products, etc.).

1.  Open your **Supabase Dashboard**.
2.  Go to the **SQL Editor** (sidebar icon looking like `>_`).
3.  Click **"New Query"**.
4.  Copy ALL the code from this file in your project:
    - `c:\Users\gunny\developing\Nextgenorganics-main\next-flutter\supabase_schema.sql`
5.  Paste it into Supabase and click **RUN**.
6.  _Result: Success message._

---

## 🌱 Step 2: Load Seed Data (Vendors & Products)

This fills your database with 15 Hyderabad Vendors and 750 Products.

1.  In Supabase SQL Editor, click **"New Query"** (again).
2.  Copy ALL the code from this file:
    - `c:\Users\gunny\developing\Nextgenorganics-main\next-flutter\seed_data.sql`
3.  Paste it into Supabase and click **RUN**.
4.  _Result: "Success. No rows returned."_

---

## 👤 Step 3: Create Login Accounts (Manual)

You must create the actual users so they can log in.

1.  Go to **Authentication** (sidebar icon looking like 🔒).
2.  Click **"Add User"** button.
3.  Create the following users one by one:

| Role          | Email                      | Password     |
| :------------ | :------------------------- | :----------- |
| **Admin**     | `admin@nextgen.com`        | `Admin@123`  |
| **Vendor 1**  | `greenvalley@nextgen.com`  | `Vendor@123` |
| **Vendor 2**  | `telangana@nextgen.com`    | `Vendor@123` |
| **Vendor 3**  | `deccan@nextgen.com`       | `Vendor@123` |
| **Vendor 4**  | `nizamabad@nextgen.com`    | `Vendor@123` |
| **Vendor 5**  | `secunderabad@nextgen.com` | `Vendor@123` |
| **Vendor 6**  | `karimnagar@nextgen.com`   | `Vendor@123` |
| **Vendor 7**  | `warangal@nextgen.com`     | `Vendor@123` |
| **Vendor 8**  | `medak@nextgen.com`        | `Vendor@123` |
| **Vendor 9**  | `adilabad@nextgen.com`     | `Vendor@123` |
| **Vendor 10** | `khammam@nextgen.com`      | `Vendor@123` |
| **Vendor 11** | `nalgonda@nextgen.com`     | `Vendor@123` |
| **Vendor 12** | `mahbubnagar@nextgen.com`  | `Vendor@123` |
| **Vendor 13** | `rangareddy@nextgen.com`   | `Vendor@123` |
| **Vendor 14** | `hyderabad@nextgen.com`    | `Vendor@123` |
| **Vendor 15** | `banjara@nextgen.com`      | `Vendor@123` |

---

## 🔐 Step 4: Assign Roles (Crucial)

By default, everyone is just a "customer". You must tell the database who is a **Vendor** and who is **Admin**.

1.  Go back to **SQL Editor**.
2.  Click **"New Query"**.
3.  Copy and Paste the code below and click **RUN**:

```sql
-- 1. SET ADMIN ROLE
UPDATE public.profiles SET role = 'admin' WHERE email = 'admin@nextgen.com';

-- 2. SET VENDOR ROLES & LINK TO MANUFACTURER PROFILES
UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'green-valley-organics') WHERE email = 'greenvalley@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'telangana-fresh-farms') WHERE email = 'telangana@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'deccan-harvest') WHERE email = 'deccan@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'nizamabad-naturals') WHERE email = 'nizamabad@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'secunderabad-greens') WHERE email = 'secunderabad@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'karimnagar-krishi') WHERE email = 'karimnagar@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'warangal-wellness') WHERE email = 'warangal@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'medak-meadows') WHERE email = 'medak@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'adilabad-agro') WHERE email = 'adilabad@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'khammam-kisan') WHERE email = 'khammam@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'nalgonda-nature') WHERE email = 'nalgonda@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'mahbubnagar-millets') WHERE email = 'mahbubnagar@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'rangareddy-roots') WHERE email = 'rangareddy@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'hyderabad-herbals') WHERE email = 'hyderabad@nextgen.com';

UPDATE public.profiles SET role = 'vendor', vendor_id = (SELECT id FROM manufacturers WHERE slug = 'banjara-hills-bio') WHERE email = 'banjara@nextgen.com';
```

---

## 🏁 Done!

Now you can log in:

- **Admin Panel**: Login with `admin@nextgen.com` -> You will see the Super Admin Dashboard.
- **Vendor Portal**: Login with `greenvalley@nextgen.com` -> You will see the Vendor Dashboard.
