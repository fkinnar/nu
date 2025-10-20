# NE FONCTIONNE PAS COMME ATTENDU !!

def note [] {
    # 1. Générer le nom de fichier et le chemin complet
    let filename = $'quicknote-(date now | format date '%Ym%d-%H%M%S').md'
    let fullpath = ($env.note | path join $filename)
    
    # 2. Commandes de Pré-Lancement : Ouvre le fichier (chemin absolu)
    let pre_cmd = $":edit ($fullpath)"
    
    # 3. Commandes de Post-Lancement : Le Autocmd est le seul garant du délai.
    #    On utilise :e . pour forcer le CWD du buffer.
    
    let post_cmd = $":write | autocmd BufWinEnter <buffer> silent! execute 'e ($env.note) | NeoTreeToggle | NeoTreeReveal | autocmd! BufWinEnter <buffer>' | startinsert"
    
    # Lancement :
    # Nous utilisons l'ouverture de fichier simple, car le CWD est de toute façon cassé par LazyVim
    nvim --cmd $pre_cmd -c $post_cmd
}
