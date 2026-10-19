cask "cloak-proxy" do
  version "0.4.2"
  sha256 "e3d30a7ecefda3d68e616c7cfe42c83ae95e1e5c111d168af5fdecf614b1fc90"

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

  uninstall launchctl: [
              "com.subcloak.cloakproxy.dns-standby",
              "com.subcloak.cloakproxy.login-proxy-guard",
            ],
            quit:      "com.subcloak.cloakproxy"

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
    Remove from Keychain, stop capturing any apps that ignore the proxy, and quit the app so
    your previous proxy settings come back. Full steps:
      https://docs.subcloak.com/cloak-proxy/getting-started/install/#uninstall-cloak-proxy-completely
  EOS
end
