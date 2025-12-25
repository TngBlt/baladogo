#!/bin/bash

echo "🐕 BalaDogo - Environnement de dev"
echo "=================================="

# Lance le serveur web en arrière-plan
cd ~/dev/baladogo
python3 -m http.server 8080 &
SERVER_PID=$!
echo "✅ Serveur de test lancé (PID: $SERVER_PID)"
echo "👉 http://localhost:8080/baladogo.html"
echo ""

# Nettoyage à la fermeture
cleanup() {
    echo ""
    echo "🧹 Arrêt du serveur..."
    kill $SERVER_PID 2>/dev/null
    echo "👋 À bientôt !"
    exit 0
}
trap cleanup EXIT INT TERM

# Lance Claude Code
echo "🚀 Lancement de Claude Code..."
echo ""
claude
