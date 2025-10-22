def grepenv [
  expression? : string,
  --insensitive(-i)
] {
  # Récupérer l'expression depuis le pipe si pas fournie en paramètre
  let pattern = if ($expression == null or $expression == '') {
    $in
  } else {
    $expression
  }

  # Ajouter le flag case-insensitive si demandé
  let final_pattern = if $insensitive {
    "(?i)" + $pattern
  } else {
    $pattern
  }

  # Filtrer les variables d'environnement
  $env | transpose key value | where key =~ $final_pattern
}
