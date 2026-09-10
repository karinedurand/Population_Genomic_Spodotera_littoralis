# FST + Dxy : Manhattan plots alignés et détection d’outliers

## Objectif
Ce script R lit, pour une ou plusieurs paires de populations, des fenêtres génomiques de FST et de Dxy, trace des Manhattan plots alignés par chromosome, détecte les outliers et identifie les régions où FST et Dxy sont simultanément élevés.

---

## Entrées attendues

### FST
Fichier TSV avec en-tête, colonnes obligatoires :
- `CHROM` : chromosome
- `BIN_START`, `BIN_END` : positions de début et fin de la fenêtre
- `N_VARIANTS` : nombre de SNP dans la fenêtre
- `WEIGHTED_FST` : valeur de FST pondérée

### Dxy
Fichier TSV avec en-tête, colonnes obligatoires :
- `chrom` : chromosome
- `window_start`, `window_end` : positions de début et fin de la fenêtre
- `Dxy` : valeur de Dxy
- `SNP` : nombre de SNP (optionnel mais recommandé)

Les noms de chromosomes peuvent être préfixés (`HiC_scaffold_`) ; le préfixe est retiré automatiquement.

---

## Paramètres principaux

| Paramètre | Valeur par défaut | Rôle |
|-----------|-------------------|------|
| `CHROM_KEEP` | `1:28` | Chromosomes conservés pour l’analyse |
| `MIN_SNP_FST` | `10` | Nombre minimum de SNP par fenêtre FST |
| `MIN_SNP_DXY` | `10` | Nombre minimum de SNP par fenêtre Dxy |
| `QUANT` | `0.99` | Quantile utilisé comme seuil outlier (top 1 %) |
| `MIN_RUN` | `2` | Nombre minimum de fenêtres outliers contiguës pour former une région |
| `COLS` | `c("darkslateblue", "cadetblue")` | Couleurs alternées des chromosomes sur les plots |

---

## Calculs effectués

1. **Préparation des fenêtres**
   - Renommage des colonnes en `chr`, `start`, `end`, `value`, `nsnp`.
   - Suppression du préfixe `HiC_scaffold_`.
   - Filtrage sur les chromosomes `CHROM_KEEP`.
   - Suppression des valeurs manquantes.
   - Filtrage sur le nombre de SNP (`MIN_SNP_FST` / `MIN_SNP_DXY`).
   - Les FST négatives sont remplacées par 0.

2. **Alignement génomique commun**
   - Les positions cumulées (`pos_cum`) sont calculées sur l’union des fenêtres FST et Dxy, afin que les deux Manhattan plots partagent exactement le même axe x.

3. **Seuils outliers**
   - `thr_fst` = quantile `QUANT` des valeurs de FST.
   - `thr_dxy` = quantile `QUANT` des valeurs de Dxy.

4. **Détection des régions outliers**
   - Une fenêtre est outlier si sa valeur dépasse le seuil.
   - Les fenêtres outliers contiguës sur un même chromosome sont regroupées en régions.
   - Seules les régions contenant au moins `MIN_RUN` fenêtres sont conservées.

5. **Intersection FST × Dxy**
   - Les régions outliers FST et Dxy sont croisées par chromosome.
   - Une fenêtre est conservée si les intervalles FST et Dxy se chevauchent (`fst_start < dxy_end` et `dxy_start < fst_end`).

---

## Fichiers de sortie

Pour chaque paire analysée (`pair_name`) :

| Fichier | Description |
|---------|-------------|
| `<pair_name>_outliers_FST_<quantile>.csv` | Fenêtres FST outliers (≥ `MIN_RUN` fenêtres contiguës) |
| `<pair_name>_outliers_DXY_<quantile>.csv` | Fenêtres Dxy outliers (≥ `MIN_RUN` fenêtres contiguës) |
| `<pair_name>_outliers_SHARED_<quantile>.csv` | Chevauchements entre régions FST et Dxy outliers |
| `Plot_FST_<pair_name>.pdf` | Manhattan plot FST seul |
| `Plot_DXY_<pair_name>.pdf` | Manhattan plot Dxy seul |
| `Combined_FST_DXY_<pair_name>.pdf` | Figure combinée FST (haut) + Dxy (bas), alignée |

De plus, deux tables d’intersection sont réécrites en CSV :
- `common_Sen1_vs_Inv_west108.csv`
- `common_Nat_C_vs_Nat_R.csv`

---

## Interprétation biologique rapide

- **FST élevé** : différenciation génétique marquée entre les deux populations.
- **Dxy élevé** : divergence absolue élevée (peut refléter une ancienne séparation ou un fort polymorphisme).
- **FST et Dxy élevés ensemble** : candidats forts pour une sélection divergente ou une barrière génique, car la différenciation relative et la divergence absolue sont simultanément importantes.

---

## Paires actuellement analysées dans le script

1. `Sen1_vs_Inv_west108`
2. `Nat_C_vs_Nat_R`
3. `Inv-east_Inv-west-sen1`
4. `Inv-west-sen1_Nat-C`

Pour ajouter une nouvelle paire, ajoutez un appel à `analyse_pair()` avec le nom, le fichier FST et le fichier Dxy correspondants.
