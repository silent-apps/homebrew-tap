# Homebrew tap des apps Silent Apps

```bash
brew install --cask silent-apps/tap/devbar
```

| Cask | App | Mises à jour |
|---|---|---|
| `devbar` | [DevBar](https://github.com/silent-apps/devbar) : caches Xcode sur disque externe, runner GitHub Actions | par l'app elle-même (Sparkle) ; le cask suit toujours la dernière release, sans montée de version |

`brew uninstall --cask devbar` lance `devcache uninstall` (agent retiré, caches remis en local) avant de supprimer l'app ;
`--zap` efface aussi les réglages et le journal.
