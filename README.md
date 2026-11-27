# Homebrew tap des apps Silent Apps

```bash
brew install --cask silent-apps/tap/devbar
```

| Cask | App | Mises à jour |
|---|---|---|
| `devbar` | [DevBar](https://github.com/silent-apps/devbar) : caches Xcode sur disque externe, runner GitHub Actions | par l'app elle-même (Sparkle) ; le cask suit toujours la dernière release, sans montée de version |

`brew uninstall --cask devbar` retire l'agent et remet les caches en local (`devcache uninstall`) quelques secondes
après la fin de brew ; `--zap` le fait tout de suite, puis efface aussi les réglages et le journal. Le résultat est
écrit dans `~/Library/Logs/devcache.log`. Si un build ou un démon Gradle retenait un cache à ce moment-là, le journal le
dit : relancer alors `~/.local/bin/devcache uninstall`.
`brew upgrade` et `brew reinstall` ne touchent ni l'agent, ni les réglages, ni les caches : Homebrew exécute le même
script avant de poser la nouvelle app, et le script ne fait rien quand `DevBar.app` est revenue entre-temps.

Homebrew garde le script de désinstallation de la version installée (`INSTALL_RECEIPT.json`). Une installation
antérieure au 27 novembre 2026 exécute donc l'ancien une dernière fois au prochain `brew upgrade` ou `brew reinstall`.
Les caches repassent alors en local : `devcache on` les remet sur le disque externe. Sinon, mettre à jour depuis DevBar
(« Rechercher les mises à jour… »).
