### ðŸ”Œ Plugins

Les plugins Ã©tendent les capacitÃ©s de NuShell avec de nouvelles commandes et fonctionnalitÃ©s. Ils sont gÃ©nÃ©ralement Ã©crits en Rust et peuvent Ãªtre installÃ©s via `cargo` ou `plugin add`.

#### ðŸ”¹OÃ¹ trouver les plugins

**Sources principales :**

- **crates.io** : [https://crates.io/search?q=nu_plugin](https://crates.io/search?q=nu_plugin)
- **GitHub** : Rechercher `nu_plugin` dans les dÃ©pÃ´ts
- **Documentation officielle** : [https://www.nushell.sh/plugins/](https://www.nushell.sh/plugins/)

**Plugins populaires :**

- `nu_plugin_polars` - Analyse de donnÃ©es avancÃ©e
- `nu_plugin_query` - RequÃªtes SQL sur les donnÃ©es
- `nu_plugin_formats` - Support de formats supplÃ©mentaires
- `nu_plugin_inc` - Gestion de versions
- `nu_plugin_gstat` - Statistiques Git

#### ðŸ”¹Installation via cargo install

```sh
# Installer un plugin depuis crates.io
cargo install nu_plugin_polars
cargo install nu_plugin_query
cargo install nu_plugin_inc

# VÃ©rifier l'installation
cargo list | grep nu_plugin
```

#### ðŸ”¹Installation via plugin add

```sh
# Ajouter un plugin (si disponible via plugin add)
plugin add nu_plugin_polars
plugin add nu_plugin_query

# Lister les plugins installÃ©s
plugin list
```

#### ðŸ”¹Initialisation et configuration

**Activer les plugins dans config.nu :**

```sh
# config.nu
# Charger les plugins
register ~/.cargo/bin/nu_plugin_polars
register ~/.cargo/bin/nu_plugin_query
register ~/.cargo/bin/nu_plugin_inc

# Configuration des plugins
$env.config = ($env.config | upsert plugins {
    polars: {
        lazy: true
        streaming: true
    }
    query: {
        default_database: "sqlite"
    }
})
```

**VÃ©rifier que les plugins sont chargÃ©s :**

```sh
# Lister les commandes disponibles
help commands | where category =~ "plugin"

# Tester un plugin
polars --help
query --help
```

#### ðŸ”¹Exemples concrets de plugins

**nu_plugin_polars - Analyse de donnÃ©es :**

```sh
# CrÃ©er un dataset de test
let sales_data = [
    {date: "2024-01-01", product: "Laptop", price: 999, quantity: 5},
    {date: "2024-01-02", product: "Mouse", price: 25, quantity: 20},
    {date: "2024-01-03", product: "Keyboard", price: 75, quantity: 15},
    {date: "2024-01-04", product: "Laptop", price: 999, quantity: 3},
    {date: "2024-01-05", product: "Monitor", price: 299, quantity: 8}
] | to csv | save sales.csv

# Analyser avec Polars
open sales.csv | polars df
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚    date    â”‚ product â”‚ price â”‚ quantity â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ 2024-01-01 â”‚ Laptop  â”‚   999 â”‚        5 â”‚
â”‚ 1 â”‚ 2024-01-02 â”‚ Mouse   â”‚    25 â”‚       20 â”‚
â”‚ 2 â”‚ 2024-01-03 â”‚ Keyboardâ”‚    75 â”‚       15 â”‚
â”‚ 3 â”‚ 2024-01-04 â”‚ Laptop  â”‚   999 â”‚        3 â”‚
â”‚ 4 â”‚ 2024-01-05 â”‚ Monitor â”‚   299 â”‚        8 â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

**OpÃ©rations avancÃ©es avec Polars :**

```sh
# Calculer le chiffre d'affaires par produit
open sales.csv | polars df | polars group-by product | polars agg [
    (polars col quantity * polars col price | polars sum | polars alias "total_revenue")
    (polars col quantity | polars sum | polars alias "total_quantity")
]

# Filtrer les produits avec un CA > 1000
open sales.csv | polars df | polars filter (polars col price * polars col quantity > 1000)

# Statistiques descriptives
open sales.csv | polars df | polars describe
```

**nu_plugin_query - RequÃªtes SQL :**

```sh
# CrÃ©er une base de donnÃ©es SQLite
let employees = [
    {id: 1, name: "Alice", department: "IT", salary: 75000},
    {id: 2, name: "Bob", department: "HR", salary: 65000},
    {id: 3, name: "Charlie", department: "IT", salary: 80000},
    {id: 4, name: "Diana", department: "Finance", salary: 70000}
] | to csv | save employees.csv

# Convertir en base SQLite
open employees.csv | into sqlite employees.db

# RequÃªtes SQL
open employees.db | query db "SELECT department, AVG(salary) as avg_salary FROM main GROUP BY department"

open employees.db | query db "SELECT * FROM main WHERE salary > 70000 ORDER BY salary DESC"
```

**nu_plugin_inc - Gestion de versions :**

```sh
# IncrÃ©menter une version
inc --major 1.2.3    # 2.0.0
inc --minor 1.2.3    # 1.3.0
inc --patch 1.2.3    # 1.2.4

# Utilisation dans un script de dÃ©ploiement
def bump-version [version_type: string] {
    let current_version = (open Cargo.toml | lines | where $it =~ "version" | parse "version = \"{version}\"" | get version.0)
    let new_version = (inc --$version_type $current_version)

    print $"Version mise Ã  jour: ($current_version) -> ($new_version)"

    # Mettre Ã  jour le fichier Cargo.toml
    open Cargo.toml | str replace $"version = \"($current_version)\"" $"version = \"($new_version)\"" | save Cargo.toml

    # CrÃ©er un tag Git
    git add Cargo.toml
    git commit -m $"Bump version to ($new_version)"
    git tag $"v($new_version)"
}
```

#### ðŸ”¹Autres plugins utiles

**nu_plugin_formats - Formats supplÃ©mentaires :**

```sh
# Support pour TOML
echo "title = 'Mon projet'
version = '1.0.0'
[author]
name = 'Alice'
email = 'alice@example.com'" | save config.toml

open config.toml | from toml

# Support pour YAML
echo "database:
  host: localhost
  port: 5432
  name: myapp
  user: admin" | save config.yaml

open config.yaml | from yaml
```

**nu_plugin_gstat - Statistiques Git :**

```sh
# Statistiques du dÃ©pÃ´t Git
gstat

# Statistiques pour un auteur spÃ©cifique
gstat --author "Alice"

# Statistiques pour une pÃ©riode
gstat --since "2024-01-01" --until "2024-12-31"
```

#### ðŸ”¹CrÃ©er un plugin simple

**Structure d'un plugin minimal :**

```rust
// src/main.rs
use nu_plugin::{serve_plugin, EvaluatedCall, LabeledError, MsgPackSerializer, Plugin};
use nu_protocol::{Category, PluginSignature, SyntaxShape, Value};

struct MyPlugin;

impl Plugin for MyPlugin {
    fn signature(&self) -> Vec<PluginSignature> {
        vec![PluginSignature::build("my-command")
            .desc("Ma commande personnalisÃ©e")
            .required("input", SyntaxShape::String, "EntrÃ©e Ã  traiter")
            .category(Category::Custom("MyPlugin".into()))]
    }

    fn run(
        &mut self,
        name: &str,
        call: &EvaluatedCall,
        input: &Value,
    ) -> Result<Value, LabeledError> {
        match name {
            "my-command" => {
                let input_str: String = call.req(0)?;
                let result = format!("Traitement de: {}", input_str);
                Ok(Value::String { val: result, span: call.head })
            }
            _ => Err(LabeledError {
                label: "Commande inconnue".into(),
                msg: format!("Commande '{}' non reconnue", name),
                span: Some(call.head),
            }),
        }
    }
}

fn main() {
    serve_plugin(&mut MyPlugin, MsgPackSerializer {})
}
```

**Cargo.toml :**

```toml
[package]
name = "nu_plugin_myplugin"
version = "0.1.0"
edition = "2021"

[dependencies]
nu-plugin = "0.87"
nu-protocol = "0.87"
```

**Installation et utilisation :**

```sh
# Compiler le plugin
cargo build --release

# Installer
cargo install --path .

# Enregistrer dans NuShell
register ~/.cargo/bin/nu_plugin_myplugin

# Utiliser
my-command "Hello World"
```

#### ðŸ”¹Bonnes pratiques pour les plugins

1. **Nommage** : Utiliser le prÃ©fixe `nu_plugin_`
2. **Documentation** : Inclure des exemples d'usage
3. **Gestion d'erreurs** : Messages d'erreur clairs
4. **Performance** : Optimiser pour les gros datasets
5. **Tests** : Inclure des tests unitaires
6. **Configuration** : Permettre la personnalisation
7. **CompatibilitÃ©** : Tester avec diffÃ©rentes versions de NuShell

> Les plugins permettent d'Ã©tendre considÃ©rablement les capacitÃ©s de NuShell tout en gardant le shell lÃ©ger et modulaire.
