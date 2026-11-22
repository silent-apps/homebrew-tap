cask "devbar" do
  # DevBar updates itself with Sparkle (auto_updates): the cask follows the latest release
  # instead of pinning one, so it never needs a bump. The archive's EdDSA signature and its
  # Developer ID notarization are what vouch for it, checked by Sparkle and Gatekeeper.
  version :latest
  sha256 :no_check

  url "https://github.com/silent-apps/devbar/releases/latest/download/DevBar.zip"
  name "DevBar"
  desc "Menu bar app for Xcode caches on an external disk and a GitHub runner"
  homepage "https://github.com/silent-apps/devbar"

  auto_updates true
  depends_on arch: :arm64
  depends_on formula: "gh"
  depends_on macos: :sonoma

  app "DevBar.app"

  # agent removed and caches put back on the internal disk before the app goes
  uninstall script: {
    executable:   "#{appdir}/DevBar.app/Contents/Resources/devcache",
    args:         ["uninstall"],
    must_succeed: false,
  }

  zap trash: [
    "~/.config/devbar",
    "~/.config/devcache",
    "~/Library/Application Support/devcache",
    "~/Library/Logs/devcache.log",
  ]
end
