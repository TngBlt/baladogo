# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**BalaDogo** is a single-file web application for discovering dog walking routes. It's a self-contained HTML file containing all CSS, JavaScript, and UI components. The app uses OpenStreetMap data via Overpass API to find hiking trails and walking routes within a specified radius and duration range.

**Key characteristics:**
- Single-file architecture: `baladogo.html` contains everything (HTML, CSS, JS)
- No build system or package manager
- Pure vanilla JavaScript (no frameworks)
- Client-side only, no backend

## Development Commands

### Local Development
```bash
./dev.sh
```
This script:
- Starts a Python HTTP server on port 8080
- Opens the app at `http://localhost:8080/baladogo.html`
- Launches Claude Code
- Cleans up the server on exit

**Manual alternative:**
```bash
python3 -m http.server 8080
# Then open http://localhost:8080/baladogo.html
```

### Deployment
```bash
./deploy.sh
```
Copies `baladogo.html` to `/var/www/my_webapp/www/index.html` and deploys to https://nuuull.org/baladogo/

## Architecture

### Single-File Structure

The `baladogo.html` file is organized as follows:
1. **HTML head**: External dependencies (Leaflet, fonts, Phosphor icons)
2. **CSS styles** (lines ~10-780): Complete styling including dark/light themes, responsive grid layout
3. **HTML body** (lines ~780): Three-column layout (sidebar, map area, right panel)
4. **JavaScript** (lines ~785+): All application logic

### Core State Management

**Global state variables** (baladogo.html:856-862):
- `map`: Leaflet map instance
- `userLocation`: Current search location `{lat, lng, name}`
- `walks`, `allWalks`: Current and complete route results
- `favorites`: User-saved routes (persisted to localStorage)
- `searchHistory`: Recent location searches (persisted to localStorage)
- `hiddenWalks`: Routes hidden by user (persisted to localStorage)
- `markersLayer`, `routesLayer`, `allRoutesLayer`: Leaflet layer groups

**Constants:**
- `WALKING_SPEED = 4` km/h - Used for duration calculations
- `STORAGE_KEY = 'baladog_data'` - localStorage key
- `PAGE_SIZE = 30` - Results pagination size

### Key Data Flow

1. **Location Input** → `locateCity()` or `useGPS()`
2. **Geocoding** → Nominatim API (OpenStreetMap)
3. **Route Search** → `searchWalksProgressive()` → Overpass API queries
4. **Route Processing** → `parseHikingRoutes()` → Creates route objects with geometry
5. **Scoring** → Multiple scoring functions (environment, difficulty, crowding, sunlight)
6. **Filtering** → `filterAndCombine()` → Applies duration, type, and advanced filters
7. **Display** → `displayResults()` → Renders cards and map layers

### External APIs

The app integrates with these public APIs:

1. **Nominatim** (geocoding): `https://nominatim.openstreetmap.org/`
   - Used in `locateCity()` and `useGPS()` for address/coordinate conversion

2. **Overpass API** (OSM data): Two fallback servers
   - Primary: `https://overpass-api.de/api/interpreter`
   - Fallback: `https://overpass.kumi.systems/api/interpreter`
   - Queries for hiking routes, footways, paths, cycleways
   - See `queryOverpass()` for retry logic

3. **Open-Meteo** (weather): `https://api.open-meteo.com/v1/forecast`
   - Current conditions and 6-hour forecast
   - Used in `fetchWeather()`

4. **Open-Elevation**: `https://api.open-elevation.com/api/v1/lookup`
   - Elevation profiles for selected routes
   - Used in `fetchElevation()`

### Route Scoring System

Routes are scored across four dimensions (see baladogo.html:1618-1675):

- **Environment Score**: Favors parks, forests, nature reserves, water features
- **Difficulty Score**: Based on surface type and highway classification
- **Crowding Score**: Penalizes major roads, favors quiet paths
- **Sunlight Score**: Considers tree coverage and cardinal directions

Each score is 0-100, displayed as colored progress bars in the UI.

### DOM Caching Pattern

The app uses a `DOM` object (baladogo.html:798-825) to cache all DOM references, initialized once via `initDOMCache()`. This avoids repeated `getElementById()` calls throughout the codebase.

**Pattern:**
```javascript
const DOM = { searchBtn: null, cityInput: null, ... };
function initDOMCache() { DOM.searchBtn = document.getElementById('searchBtn'); ... }
```

### Progressive Search Algorithm

The `searchWalksProgressive()` function (baladogo.html:1371+) implements a smart search strategy:

1. Starts with a small radius (2km or user minimum)
2. Queries Overpass API for routes
3. If insufficient results, incrementally increases radius
4. Continues until enough routes found or max radius reached
5. Updates UI progressively with "Recherche en cours..." messages

This approach balances API load with result quality.

### Storage Schema

localStorage stores three collections under `STORAGE_KEY`:

```javascript
{
  favorites: [{walk object with full route data}],
  history: [{name, lat, lng}, ...],  // Max 10 entries
  hiddenWalks: [route_id, ...]
}
```

Managed by `loadStoredData()` and `saveStoredData()`.

## Testing Considerations

Since there's no test suite, manual testing should cover:

1. **Location search**: City name geocoding, GPS location
2. **Route filtering**: Duration ranges, route types (hiking, cycling, etc.)
3. **Advanced filters**: Environment, difficulty, crowding, sunlight sliders
4. **Map interactions**: Layer switching (OSM, Topo, Satellite), route visualization
5. **Favorites**: Add/remove, persistence across sessions
6. **Responsive layout**: Test on mobile, tablet, desktop breakpoints
7. **Edge cases**: No results, API failures, slow connections

## Common Modifications

### Adding New Route Types

1. Update the route type checkboxes in HTML (around line 570)
2. Modify the Overpass query builder in `searchWalksProgressive()` to include new OSM tags
3. Update the `typeFilter` logic in `filterAndCombine()`

### Adjusting Scoring Algorithms

Scoring functions are standalone (baladogo.html:1618-1675):
- `calculateEnvironmentScore()`
- `calculateDifficultyScore()`
- `calculateCrowdingScore()`
- `calculateSunlightScore()`

Each takes a route object and returns 0-100. Modify tag weights or add new criteria as needed.

### Theming

Dark/light mode toggle is handled by:
- `initTheme()` - Loads saved preference
- CSS variables in `:root` (dark mode) and `.light-mode` (light mode)
- Theme state stored in localStorage as `'baladog_theme'`

## Important Implementation Notes

### API Rate Limiting
- Overpass API has rate limits; `fetchWithTimeout()` includes 30s timeout
- `debounce()` utility prevents excessive API calls on user input
- Progressive search minimizes queries by starting small

### Coordinate Systems
- Leaflet uses `[lat, lng]` order
- OSM/Overpass uses `[lon, lat]` order in ways
- Be careful when converting between systems (see `parseHikingRoutes()`)

### Route Geometry
- Routes are stored as `coordinates: [[lat,lng], ...]`
- Circular routes detected via haversine distance between endpoints
- Use `INTERSECTION_THRESHOLD = 0.08` km for circle detection

### Performance Optimization
- DOM references cached to avoid repeated queries
- Results pagination (30 per page) prevents rendering lag
- Map layers grouped (`markersLayer`, `routesLayer`) for efficient updates
- All routes layer toggled separately to reduce map clutter
