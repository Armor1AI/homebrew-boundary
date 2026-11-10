# Rendered from armor1-runtime tools/brew/armor1-boundary.rb.in by tools/pkg/publish.sh; edit the template, not the tap.
class Armor1Boundary < Formula
  desc "Run coding agents in a sandbox governed by your organization's policy"
  homepage "https://armor1.ai"
  url "https://github.com/Armor1AI/homebrew-boundary/releases/download/v0.1.42/armor1-boundary-0.1.42.tar.gz"
  sha256 "60444410e07df6102f737398bee24d1ad42ea664339a50a1a643c14a8cf86595"
  # Proprietary: SPDX has no identifier for it, and this is Homebrew's value for that (ARM-1477).
  license :cannot_represent

  depends_on arch: :arm64
  depends_on :macos
  depends_on "openssl@3"

  def install
    # The same payload the .pkg installs. The marker tells setup it runs from Homebrew (ARM-1473).
    libexec.install Dir["*"]
    (libexec/"INSTALLER").write "brew\n"
    # opt_libexec, not libexec: the account's install records this path, and it survives upgrades.
    (bin/"armor1-boundary").write_env_script libexec/"brew/armor1-boundary", ARMOR1_BREW_APP: opt_libexec
  end

  def caveats
    <<~EOS
      Boundary also needs Docker Desktop or OrbStack, installed and started once, and the
      Xcode Command Line Tools (xcode-select --install).

      Then sign in:
        armor1-boundary login

      The first armor1-boundary command sets Boundary up for your account, and again after
      each upgrade (a few minutes). Upgrade with the full name, which also keeps it trusted:
        brew upgrade armor1ai/boundary/armor1-boundary
      To remove it, run armor1-boundary uninstall first, then brew uninstall armor1-boundary.
    EOS
  end

  test do
    # A fresh account answers from the formula's VERSION without running setup.
    assert_equal "armor1-boundary #{version}", shell_output("#{bin}/armor1-boundary --version").strip
  end
end
