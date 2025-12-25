# 🐕 BalaDogo

**Application web pour découvrir des balades canines à proximité**

BalaDogo est une application interactive qui vous aide à trouver les meilleures balades pour votre chien. Recherchez des itinéraires de randonnée et des sentiers pédestres adaptés selon vos critères : durée, distance, type de terrain, et bien plus encore.

🌐 **Demo live** : [https://nuuull.org/baladogo/](https://nuuull.org/baladogo/)

## ✨ Fonctionnalités

- 🗺️ **Recherche géolocalisée** : Trouvez des balades par ville ou utilisez votre position GPS
- ⏱️ **Filtrage avancé** : Définissez la durée (30-240 min), le rayon de recherche (5-30 km), et le type d'itinéraire
- 📊 **Système de notation intelligent** :
  - Score environnemental (parcs, forêts, points d'eau)
  - Score de difficulté (type de surface, dénivelé)
  - Score de fréquentation (sentiers calmes vs zones passantes)
  - Score d'ensoleillement (ombre vs plein soleil)
- 🗺️ **Carte interactive** : Visualisation Leaflet avec 3 types de fonds de carte (OSM, Topo, Satellite)
- 📈 **Profil d'élévation** : Visualisez le dénivelé de chaque parcours
- ⭐ **Favoris** : Sauvegardez vos balades préférées (stockage local)
- 🌤️ **Météo en temps réel** : Conditions actuelles et prévisions sur 6h
- 🎨 **Thème clair/sombre** : Interface adaptable à vos préférences
- 📱 **Responsive** : Fonctionne sur mobile, tablette et desktop
- 💾 **Hors ligne** : Historique et favoris sauvegardés localement

## 🚀 Utilisation

1. Ouvrez l'application : [https://nuuull.org/baladogo/](https://nuuull.org/baladogo/)
2. Entrez une ville ou utilisez le GPS
3. Ajustez les filtres (rayon, durée, type de terrain)
4. Explorez les résultats et cliquez sur une balade pour voir les détails
5. Ajoutez vos favoris et téléchargez les tracés GPX

## 🛠️ Technologies

- **Frontend** : HTML5, CSS3, JavaScript (Vanilla)
- **Cartographie** : [Leaflet.js](https://leafletjs.com/)
- **Données géographiques** : [OpenStreetMap](https://www.openstreetmap.org/) via [Overpass API](https://overpass-api.de/)
- **Géocodage** : [Nominatim](https://nominatim.org/)
- **Météo** : [Open-Meteo](https://open-meteo.com/)
- **Élévation** : [Open-Elevation](https://open-elevation.com/)
- **Icônes** : [Phosphor Icons](https://phosphoricons.com/)
- **Polices** : Nunito & Fraunces (Google Fonts)

## 💻 Développement local

### Prérequis

- Python 3 (pour le serveur de développement)
- Un navigateur web moderne

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/TngBlt/baladogo.git
cd baladogo

# Lancer le serveur de développement
./dev.sh
```

Le script `dev.sh` démarre automatiquement un serveur HTTP sur le port 8080 et ouvre l'application dans votre navigateur.

**Alternative manuelle** :
```bash
python3 -m http.server 8080
# Puis ouvrez http://localhost:8080/baladogo.html
```

### Déploiement

```bash
./deploy.sh
```

Ce script copie `baladogo.html` vers le répertoire de production configuré.

## 📁 Structure du projet

```
baladogo/
├── baladogo.html      # Application complète (HTML + CSS + JS)
├── dev.sh            # Script de développement
├── deploy.sh         # Script de déploiement
├── CLAUDE.md         # Documentation pour Claude Code
└── README.md         # Ce fichier
```

## 🏗️ Architecture

L'application est conçue comme un **fichier HTML unique** contenant :
- Tous les styles CSS (thème sombre/clair, responsive design)
- Toute la logique JavaScript (recherche, filtrage, cartographie)
- L'interface utilisateur complète

**Avantages** :
- Déploiement ultra-simple (un seul fichier)
- Pas de build system nécessaire
- Fonctionne directement sans serveur (sauf contraintes CORS)
- Code facile à maintenir et à partager

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs via les [Issues](https://github.com/TngBlt/baladogo/issues)
- Proposer des améliorations
- Soumettre des Pull Requests

## 📝 License

Ce projet est open source. Consultez le fichier LICENSE pour plus de détails.

## 🙏 Remerciements

- [OpenStreetMap](https://www.openstreetmap.org/) et sa communauté pour les données cartographiques
- Tous les contributeurs des APIs utilisées (Open-Meteo, Open-Elevation, Nominatim)
- La communauté Leaflet.js

---

Fait avec ❤️ pour les amoureux des chiens et des balades en nature
