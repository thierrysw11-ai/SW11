# ================================
# Graph Node Local Stack Starter
# ================================

Write-Host "🚀 Cleaning up old containers..."
docker rm -f graph-node graph-node-postgres ipfs-node 2>$null

# -------------------------------
# 1. Start Postgres
# -------------------------------
Write-Host "🗄️  Starting Postgres..."
docker run -d `
  --name graph-node-postgres `
  -p 5432:5432 `
  -e POSTGRES_USER=postgres `
  -e POSTGRES_PASSWORD=letmein `
  -e POSTGRES_DB=graphnode `
  postgres:14

# -------------------------------
# 2. Start IPFS
# -------------------------------
Write-Host "🧩 Starting IPFS..."
docker run -d `
  --name ipfs-node `
  -p 5001:5001 -p 8080:8080 `
  ipfs/kubo:latest

# -------------------------------
# 3. Start Graph Node
# -------------------------------
Write-Host "⚙️  Starting Graph Node..."
docker run -d `
  --name graph-node `
  -p 8000:8000 `
  -p 8001:8001 `
  -p 8020:8020 `
  -p 8030:8030 `
  -p 8040:8040 `
  -e postgres_host=host.docker.internal `
  -e postgres_user=postgres `
  -e postgres_pass=letmein `
  -e postgres_db=graphnode `
  -e ipfs=http://host.docker.internal:5001 `
  graphprotocol/graph-node `
  -- --ethereum-rpc arbitrum-one:https://arb1.arbitrum.io/rpc

# -------------------------------
# 4. Wait for services
# -------------------------------
Write-Host "⏳ Waiting for containers to initialize..."
Start-Sleep -Seconds 10

# -------------------------------
# 5. Check health
# -------------------------------
Write-Host "📡 Checking Graph Node health..."
try {
    $response = Invoke-WebRequest -Uri http://localhost:8000/health -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ Graph Node health check passed:" $response.Content
} catch {
    Write-Host "⚠️  Could not connect to Graph Node yet. Try 'docker logs -f graph-node'"
}

Write-Host "`n✅ All containers started! Use these ports:"
Write-Host "   - GraphQL API:      http://localhost:8000"
Write-Host "   - Graph Node Admin: http://localhost:8020"
Write-Host "   - IPFS API:         http://localhost:5001"
Write-Host "   - IPFS Web UI:      http://localhost:8080/webui"
Write-Host "`nUse 'docker logs -f graph-node' to monitor logs."
