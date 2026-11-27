cask "devbar" do
  # DevBar updates itself with Sparkle (auto_updates): the cask follows the latest release
  # instead of pinning one, so it never needs a bump. The archive's EdDSA signature and its
  # Developer ID notarization are what vouch for it, checked by Sparkle and Gatekeeper.
  # Served by the public Pages site of the private devbar repository.
  version :latest
  sha256 :no_check

  url "https://silent-apps.github.io/devbar/DevBar.zip"
  name "DevBar"
  desc "Menu bar app for Xcode caches on an external disk and a GitHub runner"
  homepage "https://github.com/silent-apps/devbar"

  auto_updates true
  depends_on arch: :arm64
  depends_on formula: "gh"
  depends_on macos: :sonoma

  app "DevBar.app"

  # Agent removed and caches put back on the internal disk once the app is gone. Homebrew runs this stanza on
  # `brew upgrade` and `brew reinstall` too, just before the next DevBar.app replaces this one, and tells the script
  # nothing: run at once, it put every cache back on the internal disk at each upgrade. So it copies devcache aside
  # and checks again in the background once brew has exited: DevBar.app back in place is an upgrade, and nothing is
  # touched; no app and the agent still there is an uninstall, and devcache uninstall runs, its output in the log.
  uninstall script: {
    executable:   "/bin/sh",
    args:         ["-c", <<~SH, "sh", "#{appdir}/DevBar.app"],
      app=$1 brew=$PPID
      tool="$HOME/Library/Application Support/devcache/devcache"
      [ -x "$tool" ] || tool="$app/Contents/Resources/devcache"
      plist="$HOME/Library/LaunchAgents/com.silentapps.devcache.plist"
      log="$HOME/Library/Logs/devcache.log"
      [ -x "$tool" ] || exit 0
      mkdir -p "$HOME/Library/Caches" "${log%/*}" || exit 0
      find "$HOME/Library/Caches" -maxdepth 1 -name 'devcache-uninstall.*' -mtime +1 -exec rm -f {} + 2>/dev/null
      copy=$(mktemp "$HOME/Library/Caches/devcache-uninstall.XXXXXX") || exit 0
      if ! { cp "$tool" "$copy" && chmod +x "$copy"; }; then rm -f "$copy"; exit 0; fi
      (
        i=0
        while kill -0 "$brew" 2>/dev/null && [ "$i" -lt 3600 ]; do sleep 2; i=$((i + 2)); done
        sleep 5
        if [ ! -d "$app" ] && [ -f "$plist" ]; then
          echo "$(date '+%F %T') brew uninstall: DevBar.app is gone, devcache uninstall"
          "$copy" uninstall || echo "$(date '+%F %T') devcache uninstall failed: run ~/.local/bin/devcache uninstall"
        fi
        rm -f "$copy"
      ) </dev/null >>"$log" 2>&1 &
    SH
    must_succeed: false,
  }

  # --zap cannot wait: the files below go at once, devcache's own copy among them
  zap script: {
        executable:   "/bin/sh",
        args:         ["-c", <<~SH],
          tool="$HOME/Library/Application Support/devcache/devcache"
          [ ! -x "$tool" ] || "$tool" uninstall
        SH
        must_succeed: false,
      },
      trash:  [
        "~/.config/devbar",
        "~/.config/devcache",
        "~/Library/Application Support/devcache",
        "~/Library/Logs/devcache.log",
      ]
end
