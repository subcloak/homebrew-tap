cask "cloak-proxy" do
  version "0.6.0"
  sha256 "fe580bdfde064052d2f2df6e7b6aa5a28921ee8d4b372a094bf7260d0426c898"

  url "https://github.com/subcloak/cloak-proxy/releases/download/v#{version}/Cloak-Proxy.dmg"
  name "Cloak Proxy"
  desc "HTTPS debugging proxy, API client and MCP server"
  homepage "https://subcloak.com/apps/cloak-proxy"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Cloak Proxy.app"
  binary "#{appdir}/Cloak Proxy.app/Contents/Resources/cloakctl"

  # App Capture's network extension can only be removed by the app that contains it: the app's own command does it
  # without opening a window (exits 0 when it's removed or was never installed).
  uninstall launchctl: [
              "com.subcloak.cloakproxy.dns-standby",
              "com.subcloak.cloakproxy.login-proxy-guard",
            ],
            quit:      "com.subcloak.cloakproxy",
            script:    {
              executable: "#{appdir}/Cloak Proxy.app/Contents/MacOS/CloakProxy",
              args:       ["--remove-network-extension"],
            }

  zap trash: [
    "~/Library/Application Support/CloakProxy",
    "~/Library/Caches/CloakProxy",
    "~/Library/Caches/com.subcloak.cloakproxy",
    "~/Library/LaunchAgents/com.subcloak.cloakproxy.dns-standby.plist",
    "~/Library/LaunchAgents/com.subcloak.cloakproxy.login-proxy-guard.plist",
    "~/Library/Preferences/com.subcloak.cloakproxy.plist",
  ]

  caveats <<~EOS
    Before uninstalling, remove Cloak Proxy's root certificate in Settings > Certificate >
    Remove from Keychain, stop capturing any apps that ignore the proxy (DNS capture), and quit the app so
    your previous proxy settings come back. Full steps:
      https://docs.subcloak.com/cloak-proxy/getting-started/install/#uninstall-cloak-proxy-completely
  EOS
end
