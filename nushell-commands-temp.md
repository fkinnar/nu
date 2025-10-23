# Commandes Nushell utiles - Mémoire temporaire

## Récupération de valeurs uniques

### Supprimer les doublons

```nushell
$projects | get company_name | uniq
```

### Grouper et compter

```nushell
$projects | group-by company_name | each { |group|
  {
    company: $group.0,
    project_count: ($group.1 | length)
  }
}
```

### Entreprises avec leurs UUIDs

```nushell
$projects | select company_name company_id | uniq
```

### Trier puis dédoublonner

```nushell
$projects | get company_name | sort | uniq
```

## Filtrage de projets

### Par entreprise spécifique (UUID)

```nushell
$projects | where company_id == "MzI5MjQ3Mw=="
```

### Par nom d'entreprise

```nushell
$projects | where company_name == "IRIS FACILITY SOLUTIONS"
```

### Colonnes spécifiques

```nushell
$projects | where company_name == "Mon Entreprise" | select name description company_name
```

## Notes importantes

- `uniq` (pas `unique`) - abréviation Unix
- `sort` (pas `sorted`)
- `reverse` (pas `reversed`)
- `length` (pas `len`)

## Itération et exécution sur collections

### each - Exécuter une commande sur chaque élément

```nushell
# Appliquer une fonction à chaque élément d'une liste
["email1@iris.be", "email2@iris.be"] | each { |email|
  $email | n2f-patch-user {role: 'Administrateur'}
}

# Avec des données plus complexes
$users | each { |user|
  $user.email | n2f-patch-user {role: $user.role}
}
```

### map - Transformation de données (alias de each)

```nushell
# Même fonction que each, mais plus explicite pour les transformations
$emails | map { |email| $email | str upcase }
```

### where - Filtrage conditionnel

```nushell
# Filtrer les utilisateurs par rôle
$users | where role == "Administrateur"

# Filtrage complexe
$users | where role == "Manager" and company == "IRIS"
```

### reduce - Agrégation et réduction

```nushell
# Compter le total d'utilisateurs par entreprise
$users | group-by company | each { |group|
  { company: $group.0, count: ($group.1 | length) }
} | reduce { |acc, item|
  $acc | merge { ($item.company): $item.count }
} {}

# Calculer la somme des valeurs
[1, 2, 3, 4, 5] | reduce { |acc, item| $acc + $item } 0

# Trouver l'utilisateur avec le plus grand nombre de projets
$users | reduce { |acc, user|
  if ($user.project_count | default 0) > ($acc.project_count | default 0) {
    $user
  } else {
    $acc
  }
} {}
```

### fold - Réduction avec état (alias de reduce)

```nushell
# Même fonction que reduce, syntaxe alternative
$numbers | fold 0 { |acc, item| $acc + $item }
```

### filter - Filtrage avec fonction (alias de where)

```nushell
# Filtrage avec une fonction personnalisée
$users | filter { |user| $user.role == "Manager" and $user.active }
```

### any/all - Tests de condition

```nushell
# Vérifier si au moins un utilisateur est admin
$users | any { |user| $user.role == "Administrateur" }

# Vérifier si tous les utilisateurs sont actifs
$users | all { |user| $user.active }
```

### find - Trouver le premier élément correspondant

```nushell
# Trouver le premier utilisateur avec un email spécifique
$users | find { |user| $user.email == "admin@iris.be" }
```

### take/skip - Pagination et limitation

```nushell
# Prendre les 10 premiers utilisateurs
$users | take 10

# Ignorer les 5 premiers et prendre les 10 suivants
$users | skip 5 | take 10

# Pagination : page 2 (éléments 11-20)
$users | skip 10 | take 10
```

### sort-by - Tri personnalisé

```nushell
# Trier par nom d'utilisateur
$users | sort-by name

# Trier par rôle puis par nom
$users | sort-by role name

# Tri décroissant
$users | sort-by -r project_count
```

### merge - Fusion de données

```nushell
# Fusionner deux records
$user1 | merge $user2

# Fusionner avec des valeurs par défaut
$user | merge { role: "User", active: true }
```

### default - Valeurs par défaut

```nushell
# Utiliser une valeur par défaut si null/vide
$user.role | default "User"
$user.project_count | default 0
```

### compact - Supprimer les valeurs null/vides

```nushell
# Supprimer les utilisateurs sans email
$users | compact email

# Supprimer toutes les valeurs null
$users | compact
```

## Structure des données projets

Chaque projet contient :

- `company_id` (UUID de l'entreprise)
- `company_name` (nom de l'entreprise)
    - toutes les propriétés du projet original

## Exemples d'usage pratique

### Traitement en lot d'emails

```nushell
# Récupérer une liste d'emails et les traiter
$emails = ["user1@iris.be", "user2@iris.be", "user3@iris.be"]
$emails | each { |email| $email | n2f-patch-user {role: 'Manager'} -q }
```

### Pipeline complexe

```nushell
# Récupérer les utilisateurs, filtrer, puis patcher
n2f-users | where role == "User" | get mail | each { |email|
  $email | n2f-patch-user {role: 'Administrateur'} --verbose
}
```
