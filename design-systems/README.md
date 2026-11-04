# Design systems gallery (Power BI)

One report, thirteen pages. Every page shows the same hospital overview (5 KPI cards, 4 charts, 7 filters) in a different design system, so the systems can be compared side by side.
All data is synthetic.

A design system here is a layout (where the header and filters sit), a KPI card style, corner radius, palette and fonts. The first three are used by the Real Estate, Hospital and FinTech projects.

| # | System | Layout | KPI accent | Corners | Primary | Background |
| :-- | :-- | :-- | :-- | --: | :-- | :-- |
| 1 | Warm band | `band_right` | bar left | 10 px | `#B8472F` | `#F6F3EF` |
| 2 | Clinical rail | `rail_left` | bar left | 8 px | `#1D7A8C` | `#EEF3F8` |
| 3 | Neon night | `dark_top` | bar bottom | 12 px | `#A99BFF` | `#0E1020` |
| 4 | Teal band left | `band_right` (filters left) | bar top | 0 px | `#0F8B8D` | `#EEF5F5` |
| 5 | Slate rail | `rail_right` | bar left | 2 px | `#3E6FB0` | `#EDF0F4` |
| 6 | Minimal line | `light_top` | bar bottom | 4 px | `#111827` | `#F9FAFB` |
| 7 | Navy and gold | `icon_rail` | bar left | 6 px | `#B8860B` | `#F4F1EA` |
| 8 | Corporate blue | `two_tier` | bar top | 4 px | `#1565C0` | `#EAF0F7` |
| 9 | Pastel mosaic | `mosaic` | bar bottom | 16 px | `#6C5B7B` | `#FBF4F0` |
| 10 | Editorial | `editorial` | bar bottom | 0 px | `#B3261E` | `#FFFFFF` |
| 11 | Amber on charcoal | `dark_split` | bar left | 8 px | `#F2A93B` | `#14161B` |
| 12 | Gradient band | `tall_band` | bar top | 12 px | `#7B3FB5` | `#F6F1FA` |
| 13 | Compact analyst | `compact` | bar left | 3 px | `#2F7D4F` | `#F0F2EF` |

## How to use

Open `pbip/DesignSystems.pbip` in Power BI Desktop. Set the `DataFolder` parameter to this folder's `dataaw\` (with a trailing backslash) and refresh. Each page tab is one design system.
Other projects pick a system by name in `tools/projects/gallery.py` (`SYSTEMS`).
