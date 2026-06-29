#!/usr/bin/env bash
# =============================================================================
# Security guardrails. Fails CI if a known hardening regresses, so the
# protections from the security audit can't be silently undone in a later edit.
# Runtime defences (RLS, the access_links length CHECK constraint, CSP) still
# apply regardless; this catches mistakes before they ship.
# =============================================================================
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "  ✗ $1"; fail=1; }

echo "Running security guardrails…"

# 1. Access-link tokens must be long (>= 20 chars) in the client generator.
len=$(grep -oE 'TOKEN_LEN *= *[0-9]+' src/lib/links.ts | grep -oE '[0-9]+' | head -1)
if [ -z "${len:-}" ] || [ "$len" -lt 20 ]; then
  err "src/lib/links.ts token length must be >= 20 (TOKEN_LEN found: '${len:-none}')"
fi

# 2. The service-role key must never be referenced from client code.
if grep -rniE 'SUPABASE_SERVICE_ROLE_KEY|service_?role_?key|serviceRoleKey' src >/dev/null 2>&1; then
  err "service-role key referenced in src/ — it must stay server-side only"
fi

# 3. No raw-HTML markdown bypass; sanitizer must stay in place.
if grep -rniE 'rehype-raw|rehypeRaw' src package.json >/dev/null 2>&1; then
  err "rehype-raw present — it bypasses markdown sanitization"
fi
if ! grep -q 'rehypeSanitize' src/components/Markdown.tsx; then
  err "rehype-sanitize is missing from src/components/Markdown.tsx"
fi

# 4. Security response headers must be configured.
for h in Content-Security-Policy Strict-Transport-Security X-Frame-Options X-Content-Type-Options Referrer-Policy; do
  grep -q "$h" vercel.json || err "vercel.json is missing the $h header"
done
grep -q "frame-ancestors 'none'" vercel.json || err "CSP is missing frame-ancestors 'none' (clickjacking)"

if [ "$fail" -ne 0 ]; then
  echo "❌ Security checks failed."
  exit 1
fi
echo "✅ Security checks passed."
