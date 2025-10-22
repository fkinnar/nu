def --env repos [subpath? : string] {
  mut real_path = $env.repos

  if ($subpath != null and $subpath != '') {
    $real_path = ($real_path | path join $subpath)
  }

  cd $real_path
}
