# ================================
# Build & Deploy Graph Node Subgraph
# ================================

# -------------------------------
# 1️⃣ Set paths and variables
# -------------------------------
$SubgraphDir = "C:\Users\Thier Ry\graph-node\new-subgraph"
$SubgraphName = "thier/new-subgraph"
$GraphNodeURL = "http://127.0.0.1:8020"
$IPFSURL = "http://127.0.0.1:5001"

# -------------------------------
# 2️⃣ Move to subgraph directory
# -------------------------------
Set-Location -Path "$SubgraphDir"

# -------------------------------
# 3️⃣ Build the subgraph
# -------------------------------
Write-Host "`nBuilding the subgraph..."
graph codegen
graph build subgraph.yaml --output-dir build --ipfs $IPFSURL

# -------------------------------
# 4️⃣ Deploy the subgraph
# -------------------------------
Write-Host "`nDeploying the subgraph..."
graph deploy $SubgraphName subgraph.yaml --node $GraphNodeURL --ipfs $IPFSURL

Write-Host "`n✅ Subgraph deployed!"
Write-Host "GraphQL endpoint: http://127.0.0.1:8000/subgraphs/name/$SubgraphName"
Write-Host "Graph Node status UI: http://127.0.0.1:8001"
