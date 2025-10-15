# TODO - Guide NuShell Pratique

## 📋 À faire

### 📜 Scripting - Avancé (Section future)

- [ ] Gestion d'erreurs avancée (propagation avec `?`, `try-catch` avancé)
- [ ] Modules et organisation (`module`, `use`, `export use`)
- [ ] Completions personnalisées (`def --env` pour completions)
- [ ] Configuration avancée (`config.nu`, hooks, aliases)
- [ ] Performance et optimisation (`par-each`, gros datasets)
- [ ] Intégration système (processus, redirections)
- [ ] Scripts autonomes (shebang, exécution)
- [ ] Tests et validation de scripts

### 🔌 Plugins

- [ ] Où trouver les plugins (crates.io, GitHub)
- [ ] Installation via `cargo install`
- [ ] Installation via `plugin add`
- [ ] Initialisation et configuration
- [ ] Exemples concrets :
  - [ ] `nu_plugin_polars` (analyse de données)
  - [ ] `nu_plugin_query` (requêtes SQL)
  - [ ] Autres plugins utiles

## 💡 Suggestions supplémentaires

### 🎨 Améliorations du guide existant

- [ ] Section sur les alias et raccourcis
- [ ] Configuration personnalisée (`config.nu`)
- [ ] Thèmes et personnalisation de l'interface
- [ ] Intégration avec Git (commandes Git natives)

### 🔧 Outils et utilitaires

- [ ] Chemins et navigation avancée
- [ ] Compression/décompression de fichiers
- [ ] Monitoring système (processus, mémoire, réseau)

### 📊 Analyse de données avancée

- [ ] Statistiques descriptives
- [ ] Graphiques et visualisations
- [ ] Export vers différents formats
- [ ] Manipulation de gros volumes de données

### 🌐 Intégrations

- [ ] Web scraping (avec `http get` + parsing)
- [ ] Intégration avec des services cloud (AWS, Azure, GCP)
- [ ] Webhooks et APIs temps réel
- [ ] Intégration avec des outils DevOps

## 📝 Notes

- Prioriser les sections les plus demandées/utilisées
- Garder des exemples pratiques et concrets
- Maintenir la cohérence du style existant
- Toujours inclure des liens vers la doc officielle

## ✅ Terminé

### 📚 Guide de base

- [x] Structure de base du guide
- [x] Tableaux en mémoire
- [x] Ouverture de fichiers (texte, CSV, JSON, Excel)
- [x] Conversion entre formats
- [x] Jointures entre tableaux
- [x] Intégration HTTP - API REST

### 🌍 Variables d'environnement

- [x] Accès aux variables d'environnement (`$env`)
- [x] Variables d'environnement courantes (OS, PATH, USER, etc.)
- [x] Utilisation dans les pipelines

### 🛠️ Scripts et commandes personnalisées

- [x] Concepts fondamentaux du langage (variables, types, conditions, boucles)
- [x] Opérateurs et expressions (mathématiques, logiques, chaînes)
- [x] Ranges et séquences (`1..10`, `'a'..'z'`)
- [x] Closures et fonctions anonymes (explications détaillées)
- [x] Casting et conversion de types (`into int`, `into datetime`, etc.)
- [x] Manipulation de dates (`date now`, arithmétique temporelle)
- [x] Valeur de retour des fonctions (retour automatique, `return`)
- [x] Gestion des erreurs dans les scripts (`try-catch`, `error make`)
- [x] Debugging et traçage (`debug`, `print`)
- [x] Variables d'environnement dans les scripts (modification, persistance)
- [x] Créer des commandes simples (`def`)
- [x] Exporter des commandes (`export def`)
- [x] Commandes qui modifient l'environnement (`def --env`)
- [x] Commandes complexes avec gestion d'erreurs
- [x] Wrapper de commandes externes (`def --wrapped`)
- [x] Organisation des scripts (modules, configuration)
- [x] Bonnes pratiques pour les scripts
