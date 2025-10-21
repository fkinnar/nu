def silent-spawn [
  command: string,
  file?: string  # Fichier optionnel à ouvrir
] {
  let cmd = if $file != null {
    $command + " " + $file
  } else {
    $command
  }
  job spawn { nu -c $cmd } | null
}
