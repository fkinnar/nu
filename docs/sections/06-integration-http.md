### âš™ï¸IntÃ©gration HTTP - API REST

NuShell intÃ¨gre un module de connexion HTTP aux API REST. Ce dernier simplifie grandement l'intÃ©gration avec des telles API. Les donnÃ©es reÃ§ues Ã©tant stockÃ©es en mÃ©moire de la mÃªme maniÃ¨re que le reste, on a accÃ¨s Ã  toute la puissance de NuShell pour les gÃ©rer. È¦ ma connaissance, il n'existe pas de connecteur avec des API SOAP ou GraphQL.

#### ðŸ”¹GET

```sh
http get https://api.restful-api.dev/objects
```

```sh
â•­â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚  # â”‚ id â”‚               name                â”‚       data        â”‚
â”œâ”€â”€â”€â”€â”¼â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  0 â”‚ 1  â”‚ Google Pixel 6 Pro                â”‚ {record 2 fields} â”‚
â”‚  1 â”‚ 2  â”‚ Apple iPhone 12 Mini, 256GB, Blue â”‚                   â”‚
â”‚  2 â”‚ 3  â”‚ Apple iPhone 12 Pro Max           â”‚ {record 2 fields} â”‚
â”‚  3 â”‚ 4  â”‚ Apple iPhone 11, 64GB             â”‚ {record 2 fields} â”‚
â”‚  4 â”‚ 5  â”‚ Samsung Galaxy Z Fold2            â”‚ {record 2 fields} â”‚
â”‚  5 â”‚ 6  â”‚ Apple AirPods                     â”‚ {record 2 fields} â”‚
â”‚  6 â”‚ 7  â”‚ Apple MacBook Pro 16              â”‚ {record 4 fields} â”‚
â”‚  7 â”‚ 8  â”‚ Apple Watch Series 8              â”‚ {record 2 fields} â”‚
â”‚  8 â”‚ 9  â”‚ Beats Studio3 Wireless            â”‚ {record 2 fields} â”‚
â”‚  9 â”‚ 10 â”‚ Apple iPad Mini 5th Gen           â”‚ {record 2 fields} â”‚
â”‚ 10 â”‚ 11 â”‚ Apple iPad Mini 5th Gen           â”‚ {record 2 fields} â”‚
â”‚ 11 â”‚ 12 â”‚ Apple iPad Air                    â”‚ {record 3 fields} â”‚
â”‚ 12 â”‚ 13 â”‚ Apple iPad Air                    â”‚ {record 3 fields} â”‚
â•°â”€â”€â”€â”€â”´â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

```sh
http get https://api.restful-api.dev/objects/7
```

```sh
â•­â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ id   â”‚ 7                    â”‚
â”‚ name â”‚ Apple MacBook Pro 16 â”‚
â”‚ data â”‚ {record 4 fields}    â”‚
â•°â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

> On peut aussi passer en paramÃ¨tre ``user``, ``password``, ``headers``, ``max-time`` ou d'autres paramÃ¨tres pour facilement obtenir les donnÃ©es qui nous intÃ©ressent.
> [https://www.nushell.sh/commands/docs/http_get.html](https://www.nushell.sh/commands/docs/http_get.html)

#### ðŸ”¹POST (et autres verbes)

```sh
let payload = {
    "name": "Apple MacBook Pro 16",
    "data": {
       "year": 2019,
       "price": 1849.99,
       "CPU model": "Intel Core i9",
       "Hard disk size": "1 TB"
    }
}
http post https://api.restful-api.dev/objects --content-type application/json $payload
```

```sh
â•­â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ id        â”‚ ff8081819782e69e0199ca14c2d807c2 â”‚
â”‚ name      â”‚ Apple MacBook Pro 16             â”‚
â”‚ createdAt â”‚ 2025-10-09T17:46:22.296+00:00    â”‚
â”‚ data      â”‚ {record 4 fields}                â”‚
â•°â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹OAUTH2 (et autres autorisations)

> En combinant deux requÃªtes, une premiÃ¨re pour obtenir le token, et une seconde pour effectuer la requÃªte, et en utilisant le paramÃ¨tre ``--headers`` pour passer le token, on peut simplement gÃ©rer l'autorisation.

1. RÃ©cupÃ©ration du token

```sh
let response = (
    http post "https://www.n2f.com/services/api/v2/auth"
    --content-type "application/json" {
      "client_id": $env.N2F_CLIENT_ID,
      "client_secret": $env.N2F_CLIENT_SECRET
    }
)
let token = $response.response.token
```

> ``$env.N2F_CLIENT_ID`` et ``$env.N2F_CLIENT_SECRET`` sont supposÃ©s Ãªtre dÃ©fini dans l'environnement

1. RequÃªte API

```sh
let companies = (
  http get "https://www.n2f.com/services/api/v2/companies" --headers {
    "Authorization": ("Bearer " + $token)
  }
)
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â•®
â”‚ # â”‚     uuid     â”‚          name           â”‚         address         â”‚ ... â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ MzI5MjQ3Mw== â”‚ IRIS FACILITY SOLUTIONS â”‚ Avenue de BÃ¢le 5, 1140  â”‚ ... â”‚
â”‚   â”‚              â”‚                         â”‚ Bruxelles, Belgique     â”‚     â”‚
â”‚ 1 â”‚ MzMxOTA2OA== â”‚ IRIS GROUP              â”‚ Avenue de BÃ¢le 5, 1140  â”‚ ... â”‚
â”‚   â”‚              â”‚                         â”‚ Bruxelles, Belgique     â”‚     â”‚
â”‚ 2 â”‚ MzMxOTA3Mg== â”‚ ALCYON                  â”‚ Poortakkerstraat 41D,   â”‚ ... â”‚
â”‚   â”‚              â”‚                         â”‚ 9051                    â”‚     â”‚
â”‚   â”‚              â”‚                         â”‚ Sint-Denijs-Westrem,    â”‚     â”‚
â”‚   â”‚              â”‚                         â”‚ Belgique                â”‚     â”‚
â”‚ 3 â”‚ MzMxOTA3Ng== â”‚ IRIS TECHNICAL SERVICES â”‚ Rue Ilya Progogine 2,   â”‚ ... â”‚
â”‚   â”‚              â”‚                         â”‚ 7850 Enghien, Belgique  â”‚     â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â•¯
```
