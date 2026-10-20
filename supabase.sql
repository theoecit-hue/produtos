-- Rode isso no Supabase: SQL Editor > New query > Run
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  price numeric(10,2),
  image_url text,
  link text not null,
  own boolean not null default false,
  created_at timestamptz not null default now()
);

alter table products enable row level security;

create policy "todos veem produtos" on products for select using (true);
create policy "dono adiciona" on products for insert to authenticated with check (true);
create policy "dono edita" on products for update to authenticated using (true);
create policy "dono apaga" on products for delete to authenticated using (true);

-- Pasta de fotos
insert into storage.buckets (id, name, public) values ('produtos', 'produtos', true)
on conflict (id) do nothing;

create policy "todos veem fotos" on storage.objects for select using (bucket_id = 'produtos');
create policy "dono sobe fotos" on storage.objects for insert to authenticated with check (bucket_id = 'produtos');
create policy "dono apaga fotos" on storage.objects for delete to authenticated using (bucket_id = 'produtos');
