# Guide d'utilisation des fonctions de vérification N2F

Ce dossier contient des scripts Nushell pour comparer les utilisateurs entre Agresso et
l'API N2F.

## Fichiers disponibles

- `get-users.n2f.nu` - Fonctions pour récupérer les utilisateurs depuis l'API N2F
- `get-users.agresso.nu` - Fonction pour récupérer les utilisateurs depuis Agresso
- `checks.nu` - Fonctions de comparaison et d'analyse

## Prérequis

Assurez-vous que les variables d'environnement suivantes sont définies :

- `N2F_CLIENT_ID`
- `N2F_CLIENT_SECRET`
- `AGRESSO_DB_USER`
- `AGRESSO_DB_PASSWORD`

## Utilisation

### 1. Charger les fonctions

```nushell
source checks/checks.nu
```

### 2. Fonctions de base

#### Récupérer un token N2F

```nushell
n2f-api-token
```

#### Récupérer les utilisateurs N2F

```nushell
# Avec token automatique
n2f-api-users

# Avec token spécifique
n2f-api-users "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."

# En chaînant
n2f-api-token | n2f-api-users
```

#### Récupérer les utilisateurs Agresso

```nushell
n2f-agresso-users
```

### 3. Fonctions de comparaison

#### Comparaison complète

```nushell
compare-users
```

Affiche un résumé avec le nombre d'utilisateurs dans chaque catégorie.

#### Utilisateurs présents uniquement dans Agresso

```nushell
show-agresso-only
```

Affiche les utilisateurs qui existent dans Agresso mais pas dans l'API N2F.

#### Utilisateurs présents uniquement dans l'API N2F

```nushell
show-api-only
```

Affiche les utilisateurs qui existent dans l'API N2F mais pas dans Agresso.

#### Utilisateurs présents dans les deux sources

```nushell
show-both-sources
```

Affiche les utilisateurs présents dans les deux sources avec comparaison des données.

#### Utilisateurs sans email

```nushell
show-users-without-email
```

Identifie les utilisateurs qui n'ont pas d'adresse email (ne peuvent pas être
synchronisés).

## Exemple de workflow complet

```nushell
# 1. Charger les fonctions
source checks/checks.nu

# 2. Vérifier les utilisateurs sans email
show-users-without-email

# 3. Faire la comparaison complète
compare-users

# 4. Analyser les différences
show-agresso-only    # Utilisateurs à créer dans N2F
show-api-only        # Utilisateurs à supprimer de N2F
show-both-sources    # Vérifier les différences de données
```

## Notes importantes

- La comparaison se fait sur l'adresse email (case-insensitive)
- Les utilisateurs sans email ne peuvent pas être comparés
- La fonction `n2f-api-users` gère automatiquement la pagination
- Toutes les erreurs sont gérées proprement (pas de crash du terminal)

## Résolution de problèmes

### Erreur de token

Si vous obtenez une erreur d'authentification, vérifiez vos variables d'environnement
N2F.

### Erreur de base de données

Si vous obtenez une erreur Agresso, vérifiez vos variables d'environnement de base de
données.

### Données vides

Si certaines fonctions retournent des données vides, vérifiez que les requêtes SQL et
API fonctionnent correctement.
