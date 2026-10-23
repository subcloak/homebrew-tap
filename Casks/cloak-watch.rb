cask "cloak-watch" do
  version "1.0.0"
  sha256 "3f368ed5d6d20bcfa7aab591018024d2b96758619eac08233a2dd2418fdeadae"

  url "https://download.subcloak.com/release/watch-mac/#{version}/Cloak-Watch.dmg"
  name "Cloak Watch"
  desc "Finds and fixes supply-chain attacks on developer machines"
  homepage "https://subcloak.com/apps/cloak-watch"

  livecheck do
    url "https://download.subcloak.com/api/info"
    strategy :json do |json|
      json.dig("watch-mac", "version")
    end
  end

  depends_on macos: :sonoma

  app "Cloak Watch.app"
  binary "#{appdir}/Cloak Watch.app/Contents/Resources/watchctl"

  uninstall quit: "com.subcloak.cloakwatch"

  zap trash: [
    "~/Library/Application Support/Cloak Watch",
    "~/Library/Caches/com.subcloak.cloakwatch",
    "~/Library/HTTPStorages/com.subcloak.cloakwatch",
    "~/Library/Preferences/com.subcloak.cloakwatch.plist",
  ]

  caveats <<~EOS
    Before uninstalling, turn off what Cloak Watch connected in AI Activity (its Claude Code, Cursor and Codex
    connections) so those tools don't keep calling a missing hook. If you turned on AI Activity's network extension,
    remove it in System Settings > General > Login Items & Extensions > Network Extensions
    (on macOS 14: Privacy & Security).
    `brew uninstall --zap` also deletes Cloak Watch's Quarantine folder.
  EOS
end
