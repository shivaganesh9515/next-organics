-- 📦 DATABASE SCHEMA (Supabase / PostgreSQL)

-- 1. MANUFACTURERS (The "Farm" Profiles)
create table public.manufacturers (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  slug text unique not null,
  logo_url text,
  rating numeric(2,1) default 5.0,
  is_verified boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. PRODUCTS (The Marketplace Inventory)
create table public.products (
  id uuid default gen_random_uuid() primary key,
  manufacturer_id uuid references public.manufacturers(id),
  name text not null,
  description text,
  image_url text not null,
  category text not null, -- 'vegetables', 'fruits', 'dairy'
  price_mrp numeric(10,2) not null,
  price_final numeric(10,2) not null,
  stock_quantity integer default 0,
  is_available boolean default true,
  tags text[], -- ['organic', 'best-seller']
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 3. BANNERS (The "Dynamic Home Screen" Engine)
create table public.banners (
  id uuid default gen_random_uuid() primary key,
  title text not null, -- "FRESH HARVEST"
  subtitle text, -- "Organic & Local"
  image_url text not null,
  cta_text text default 'SHOP NOW',
  target_route text, -- "/category/fruits" or "/product/{id}"
  type text default 'hero', -- 'hero', 'offer_rail', 'popup'
  gradient_colors text[], -- ['#66BB6A', '#43A047']
  is_active boolean default true,
  priority integer default 0, -- Higher number = shows first
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 4. ORDERS (Simple Order Tracking)
create table public.orders (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id),
  total_amount numeric(10,2) not null,
  status text default 'pending', -- 'pending', 'confirmed', 'out_for_delivery', 'delivered'
  items jsonb not null, -- Snapshot of products bought
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 5. PROFILES (RBAC & User Data)
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  role text default 'customer', -- 'admin', 'vendor', 'customer'
  vendor_id uuid references public.manufacturers(id), -- Linked only if role is 'vendor'
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 6. TRIGGERS (Auto-create Profile)
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, role)
  values (new.id, new.email, 'customer');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 7. RLS POLICIES (Security)
alter table public.profiles enable row level security;
alter table public.manufacturers enable row level security;
alter table public.products enable row level security;
alter table public.banners enable row level security;
alter table public.orders enable row level security;

-- Allow Public Read Access (For App)
create policy "Allow Public Read" on public.products for select using (true);
create policy "Allow Public Read" on public.banners for select using (true);
create policy "Allow Public Read" on public.manufacturers for select using (true);

-- Allow Admin Write Access (Simplistic for now)
-- In production, you would check (select role from profiles where id = auth.uid()) = 'admin'
