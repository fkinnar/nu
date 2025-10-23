# TODO - Intégration des commandes NuShell

## 📋 Objectif

Intégrer le contenu de `nushell-commands-temp.md` dans `nushell-practical.md` en enrichissant et réorganisant la documentation existante.

## 🔍 Analyse du contenu à intégrer

Le fichier temporaire contient des sections très utiles qui manquent ou sont incomplètes dans la documentation principale :

### 📝 Sections identifiées dans nushell-commands-temp.md

1. **🔄 Récupération de valeurs uniques**
   - `uniq` (pas `unique`)
   - `group-by` avec comptage
   - Dédoublonnage avec tri
   - Exemples avec données réelles

2. **🔍 Filtrage de projets/données**
   - Filtrage par UUID vs nom
   - Conditions complexes (`and`, `or`)
   - Sélection de colonnes spécifiques
   - Filtrage avec regex

3. **🔄 Itération et exécution sur collections**
   - `each` - Exécuter une commande sur chaque élément
   - `map` - Transformation de données (alias de each)
   - `where` - Filtrage conditionnel
   - `reduce` - Agrégation et réduction
   - `fold` - Réduction avec état (alias de reduce)
   - `filter` - Filtrage avec fonction (alias de where)

4. **📊 Tests et agrégation**
   - `any`/`all` - Tests de condition
   - `find` - Trouver le premier élément correspondant
   - `take`/`skip` - Pagination et limitation
   - `sort-by` - Tri personnalisé

5. **🔧 Manipulation de données**
   - `merge` - Fusion de données
   - `default` - Valeurs par défaut
   - `compact` - Supprimer les valeurs null/vides

6. **💡 Exemples pratiques**
   - Traitement en lot d'emails
   - Pipelines complexes
   - Gestion d'erreurs dans les boucles

7. **📚 Notes importantes**
   - Noms de commandes (uniq vs unique, sort vs sorted, etc.)
   - Bonnes pratiques
   - Pièges courants

## ✅ TODO List

### Phase 1 : Analyse et planification

- [x] Analyser le contenu de nushell-commands-temp.md
- [x] Identifier les sections à intégrer
- [x] Créer ce TODO.md

### Phase 2 : Intégration des sections manquantes

- [ ] **Ajouter section "Récupération de valeurs uniques"**
  - [ ] Section `uniq` avec exemples
  - [ ] Section `group-by` avec comptage
  - [ ] Dédoublonnage avec tri
  - [ ] Exemples avec données réelles

- [ ] **Enrichir section filtrage existante**
  - [ ] Filtrage par UUID vs nom
  - [ ] Conditions complexes (`and`, `or`)
  - [ ] Sélection de colonnes spécifiques
  - [ ] Filtrage avec regex avancé

- [ ] **Ajouter section complète "Itération et collections"**
  - [ ] `each` avec exemples pratiques
  - [ ] `map` (alias de each)
  - [ ] `reduce` avec agrégation
  - [ ] `fold` (alias de reduce)
  - [ ] `filter` (alias de where)

- [ ] **Ajouter section "Tests et agrégation"**
  - [ ] `any`/`all` pour les tests de condition
  - [ ] `find` pour trouver le premier élément
  - [ ] `take`/`skip` pour la pagination
  - [ ] `sort-by` avec tri multiple

- [ ] **Ajouter section "Manipulation de données"**
  - [ ] `merge` pour fusionner des records
  - [ ] `default` pour les valeurs par défaut
  - [ ] `compact` pour supprimer les null/vides

### Phase 3 : Exemples pratiques

- [ ] **Ajouter section "Exemples pratiques"**
  - [ ] Traitement en lot d'emails
  - [ ] Pipelines complexes
  - [ ] Gestion d'erreurs dans les boucles
  - [ ] Exemples avec données réelles

### Phase 4 : Notes et bonnes pratiques

- [ ] **Ajouter section "Notes importantes"**
  - [ ] Noms de commandes (uniq vs unique, sort vs sorted, etc.)
  - [ ] Bonnes pratiques
  - [ ] Pièges courants
  - [ ] Conseils d'optimisation

### Phase 5 : Réorganisation et nettoyage

- [ ] **Réorganiser le contenu existant**
  - [ ] Éviter les doublons
  - [ ] Améliorer la cohérence
  - [ ] Organiser par complexité (basique → avancé)

- [ ] **Nettoyage final**
  - [ ] Vérifier la cohérence du style
  - [ ] Tester les exemples
  - [ ] Supprimer nushell-commands-temp.md

## 🎯 Stratégie d'intégration

### Principe général

- **Éviter les doublons** avec le contenu existant
- **Enrichir les sections existantes** plutôt que de créer des doublons
- **Ajouter des exemples concrets** avec des données réalistes
- **Organiser par complexité** (basique → avancé)
- **Maintenir la cohérence** avec le style existant

### Ordre de priorité

1. **Sections manquantes** (récupération valeurs uniques, itération complète)
2. **Enrichissement des sections existantes** (filtrage, manipulation)
3. **Exemples pratiques** (cas d'usage réels)
4. **Notes et bonnes pratiques** (pièges courants)

### Points d'attention

- Vérifier que les exemples fonctionnent
- Maintenir la cohérence avec le style existant
- Éviter de surcharger le fichier principal
- Garder un équilibre entre théorie et pratique

## 📊 État d'avancement

- **Analyse** : ✅ Terminé
- **Planification** : ✅ Terminé
- **Intégration** : ⏳ En attente
- **Tests** : ⏳ En attente
- **Nettoyage** : ⏳ En attente

## 🚀 Prochaines étapes

1. Commencer par la section "Récupération de valeurs uniques"
2. Enrichir progressivement les sections existantes
3. Ajouter les exemples pratiques
4. Finaliser avec les notes et bonnes pratiques
5. Nettoyer et supprimer le fichier temporaire
