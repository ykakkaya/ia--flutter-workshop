<!doctype html>
<html lang="tr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Todo</title>
<style>
  :root { --bg:#f4f5f7; --card:#fff; --text:#1f2430; --muted:#778; --primary:#4f46e5; --danger:#dc2626; --border:#e3e5ea; }
  @media (prefers-color-scheme: dark) {
    :root { --bg:#14161b; --card:#1d2027; --text:#e8eaf0; --muted:#8a90a0; --border:#2e323c; }
  }
  * { box-sizing: border-box; }
  body { margin:0; font:16px/1.4 system-ui,sans-serif; background:var(--bg); color:var(--text); }
  main { max-width:640px; margin:0 auto; padding:32px 16px; }
  .card { background:var(--card); border:1px solid var(--border); border-radius:12px; padding:20px; }
  h1 { font-size:22px; margin:0 0 16px; }
  input[type=text],input[type=email],input[type=password] { width:100%; padding:10px 12px; margin-bottom:10px; border:1px solid var(--border); border-radius:8px; background:var(--bg); color:var(--text); font:inherit; }
  button { font:inherit; cursor:pointer; border:0; border-radius:8px; padding:10px 14px; background:var(--primary); color:#fff; }
  button.link { background:none; color:var(--primary); padding:0; }
  button.ghost { background:none; color:var(--muted); padding:4px 8px; }
  .full { width:100%; }
  .err { color:var(--danger); font-size:14px; min-height:20px; margin:0 0 8px; }
  .muted { color:var(--muted); font-size:14px; }
  .center { text-align:center; margin-top:14px; }
  header { display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
  header h1 { margin:0; }
  form.add { display:flex; gap:8px; margin-bottom:12px; }
  form.add input { margin:0; flex:1; }
  ul { list-style:none; margin:0; padding:0; }
  li { display:flex; align-items:center; gap:10px; padding:10px 0; border-top:1px solid var(--border); }
    li input[type=checkbox] { width:18px; height:18px; }
  textarea,select,input[type=datetime-local] { width:100%; padding:10px 12px; margin-bottom:10px; border:1px solid var(--border); border-radius:8px; background:var(--bg); color:var(--text); font:inherit; }
  textarea { resize:vertical; min-height:70px; }
  .row { display:flex; gap:10px; }
  .row > label { flex:1; }
  label { display:block; font-size:13px; color:var(--muted); }
  label input,label select { margin-top:4px; }
  .form-actions { display:flex; gap:8px; }
  .tabs { display:flex; gap:6px; margin:16px 0 8px; }
  .tab { background:var(--bg); color:var(--muted); border:1px solid var(--border); padding:6px 12px; font-size:14px; }
  .tab.active { background:var(--primary); color:#fff; border-color:var(--primary); }
  .tab small { opacity:.8; margin-left:4px; }
  li { align-items:flex-start; }
  li .body { flex:1; min-width:0; }
  li .title { word-break:break-word; }
  li .desc { color:var(--muted); font-size:14px; white-space:pre-wrap; word-break:break-word; margin-top:2px; }
  li .meta { display:flex; flex-wrap:wrap; gap:8px; align-items:center; margin-top:6px; font-size:12px; color:var(--muted); }
  li input[type=checkbox] { margin-top:3px; flex:none; }
  li.done .title { text-decoration:line-through; color:var(--muted); }
  .badge { padding:2px 8px; border-radius:999px; font-size:12px; font-weight:600; }
  .p-high { background:#fee2e2; color:#b91c1c; }
  .p-normal { background:#dbeafe; color:#1d4ed8; }
  .p-low { background:#e5e7eb; color:#4b5563; }
  @media (prefers-color-scheme: dark) {
    .p-high { background:#4c1d1d; color:#fca5a5; } .p-normal { background:#1e2f55; color:#93c5fd; } .p-low { background:#2e323c; color:#c0c4d0; }
  }
  .hidden { display:none; }
</style>
</head>
<body>
<main>
  <section id="auth" class="card hidden">
    <h1 id="auth-title">Giriş yap</h1>
    <form id="auth-form">
      <input id="name" type="text" placeholder="Ad" autocomplete="name" class="hidden">
      <input id="email" type="email" placeholder="E-posta" autocomplete="email" required>
      <input id="password" type="password" placeholder="Şifre" autocomplete="current-password" required>
      <input id="password2" type="password" placeholder="Şifre (tekrar)" autocomplete="new-password" class="hidden">
      <p id="auth-err" class="err"></p>
      <button class="full" id="auth-submit">Giriş yap</button>
    </form>
    <p class="center muted"><span id="switch-text">Hesabın yok mu?</span> <button class="link" id="switch">Kayıt ol</button></p>
  </section>

  <section id="todos" class="card hidden">
    <header>
      <h1>Todo'larım</h1>
      <span><span class="muted" id="who"></span> <button class="ghost" id="logout">Çıkış</button></span>
    </header>
    <form id="add-form">
      <input id="new-title" type="text" placeholder="Yeni görev..." maxlength="255" required>
      <textarea id="new-desc" placeholder="Açıklama (isteğe bağlı)" maxlength="5000"></textarea>
      <div class="row">
        <label>Öncelik
          <select id="new-priority">
            <option value="low">Düşük</option>
            <option value="normal" selected>Normal</option>
            <option value="high">Yüksek</option>
          </select>
        </label>
        <label>Başlama zamanı
          <input id="new-start" type="datetime-local">
        </label>
      </div>
      <div class="form-actions">
        <button id="save-btn">Ekle</button>
        <button type="button" class="ghost hidden" id="cancel-edit">Vazgeç</button>
      </div>
    </form>
    <p id="todo-err" class="err"></p>
    <div class="tabs" id="tabs">
      <button class="tab active" data-f="all">Tümü<small></small></button>
      <button class="tab" data-f="in_progress">Devam edenler<small></small></button>
      <button class="tab" data-f="completed">Tamamlananlar<small></small></button>
    </div>
    <ul id="list"></ul>
    <p id="empty" class="muted center hidden">Henüz görev yok.</p>
  </section>
</main>

<script>
const $ = id => document.getElementById(id);
let token = localStorage.getItem('token');
let mode = 'login';

async function api(path, opts = {}) {
  const res = await fetch('/api' + path, {
    ...opts,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...(token ? { Authorization: 'Bearer ' + token } : {}),
    },
    body: opts.body ? JSON.stringify(opts.body) : undefined,
  });
  if (res.status === 401 && token) { logout(false); throw new Error('Oturum süresi doldu.'); }
  const data = res.status === 204 ? null : await res.json();
  if (!res.ok) {
    const first = data?.errors ? Object.values(data.errors)[0][0] : null;
    throw new Error(first || data?.message || 'Bir hata oluştu.');
  }
  return data;
}

function show(view) {
  $('auth').classList.toggle('hidden', view !== 'auth');
  $('todos').classList.toggle('hidden', view !== 'todos');
}

function setMode(m) {
  mode = m;
  const reg = m === 'register';
  $('auth-title').textContent = reg ? 'Kayıt ol' : 'Giriş yap';
  $('auth-submit').textContent = reg ? 'Kayıt ol' : 'Giriş yap';
  $('switch-text').textContent = reg ? 'Zaten hesabın var mı?' : 'Hesabın yok mu?';
  $('switch').textContent = reg ? 'Giriş yap' : 'Kayıt ol';
  $('name').classList.toggle('hidden', !reg);
  $('password2').classList.toggle('hidden', !reg);
  $('name').required = $('password2').required = reg;
  $('password').autocomplete = reg ? 'new-password' : 'current-password';
  $('auth-err').textContent = '';
}

$('switch').onclick = () => setMode(mode === 'login' ? 'register' : 'login');

$('auth-form').onsubmit = async e => {
  e.preventDefault();
  $('auth-err').textContent = '';
  const body = { email: $('email').value, password: $('password').value };
  if (mode === 'register') { body.name = $('name').value; body.password_confirmation = $('password2').value; }
  try {
    const data = await api('/' + mode, { method: 'POST', body });
    token = data.token;
    localStorage.setItem('token', token);
    $('auth-form').reset();
    await loadTodos(data.user);
  } catch (err) { $('auth-err').textContent = err.message; }
};

async function logout(callApi = true) {
  if (callApi) { try { await api('/logout', { method: 'POST' }); } catch {} }
  token = null;
  localStorage.removeItem('token');
  setMode('login');
  show('auth');
}
$('logout').onclick = () => logout();

const PRIORITY = { low: 'Düşük', normal: 'Normal', high: 'Yüksek' };
let items = [];
let filter = 'all';
let editingId = null;

const pad = n => String(n).padStart(2, '0');
const toLocalInput = iso => {
  if (!iso) return '';
  const d = new Date(iso);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
};
const fmt = iso => new Date(iso).toLocaleString('tr-TR', { dateStyle: 'medium', timeStyle: 'short' });

function render() {
  const counts = { all: items.length, in_progress: items.filter(t => !t.completed).length, completed: items.filter(t => t.completed).length };
  document.querySelectorAll('#tabs .tab').forEach(b => {
    b.classList.toggle('active', b.dataset.f === filter);
    b.querySelector('small').textContent = counts[b.dataset.f];
  });

  const shown = items.filter(t => filter === 'all' || (filter === 'completed') === t.completed);
  const list = $('list');
  list.innerHTML = '';
  $('empty').classList.toggle('hidden', shown.length > 0);

  for (const t of shown) {
    const li = document.createElement('li');
    li.className = t.completed ? 'done' : '';

    const cb = Object.assign(document.createElement('input'), { type: 'checkbox', checked: t.completed });
    cb.onchange = () => act(() => api('/todos/' + t.id, { method: 'PATCH', body: { completed: cb.checked } }));

    const body = document.createElement('div');
    body.className = 'body';
    const title = Object.assign(document.createElement('div'), { className: 'title', textContent: t.title });
    body.append(title);
    if (t.description) body.append(Object.assign(document.createElement('div'), { className: 'desc', textContent: t.description }));

    const meta = document.createElement('div');
    meta.className = 'meta';
    meta.append(Object.assign(document.createElement('span'), { className: 'badge p-' + t.priority, textContent: PRIORITY[t.priority] }));
    meta.append(Object.assign(document.createElement('span'), { textContent: t.completed ? 'Tamamlandı' : 'Devam ediyor' }));
    if (t.starts_at) meta.append(Object.assign(document.createElement('span'), { textContent: '🕒 ' + fmt(t.starts_at) }));
    body.append(meta);

    const edit = Object.assign(document.createElement('button'), { className: 'ghost', textContent: '✎', title: 'Düzenle' });
    edit.onclick = () => startEdit(t);
    const del = Object.assign(document.createElement('button'), { className: 'ghost', textContent: '✕', title: 'Sil' });
    del.onclick = () => act(() => api('/todos/' + t.id, { method: 'DELETE' }));

    li.append(cb, body, edit, del);
    list.append(li);
  }
}

async function refresh() {
  items = await api('/todos');
  render();
}

async function act(fn) {
  $('todo-err').textContent = '';
  try { await fn(); await refresh(); }
  catch (err) { $('todo-err').textContent = err.message; }
}

document.querySelectorAll('#tabs .tab').forEach(b => b.onclick = () => { filter = b.dataset.f; render(); });

function resetForm() {
  editingId = null;
  $('add-form').reset();
  $('save-btn').textContent = 'Ekle';
  $('cancel-edit').classList.add('hidden');
}

function startEdit(t) {
  editingId = t.id;
  $('new-title').value = t.title;
  $('new-desc').value = t.description ?? '';
  $('new-priority').value = t.priority;
  $('new-start').value = toLocalInput(t.starts_at);
  $('save-btn').textContent = 'Kaydet';
  $('cancel-edit').classList.remove('hidden');
  $('new-title').focus();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}
$('cancel-edit').onclick = resetForm;

$('add-form').onsubmit = async e => {
  e.preventDefault();
  const title = $('new-title').value.trim();
  if (!title) return;
  const start = $('new-start').value;
  const body = {
    title,
    description: $('new-desc').value.trim() || null,
    priority: $('new-priority').value,
    starts_at: start ? new Date(start).toISOString() : null,
  };
  $('todo-err').textContent = '';
  try {
    await (editingId
      ? api('/todos/' + editingId, { method: 'PATCH', body })
      : api('/todos', { method: 'POST', body }));
    resetForm();
    await refresh();
  } catch (err) { $('todo-err').textContent = err.message; }
};

async function loadTodos(user) {
  try {
    user ??= await api('/user');
    $('who').textContent = user.name;
    show('todos');
    await refresh();
  } catch { show('auth'); }
}

setMode('login');
token ? loadTodos() : show('auth');
</script>
</body>
</html>
