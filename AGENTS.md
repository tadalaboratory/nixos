# AIエージェント向けリポジトリガイドライン

本ガイドラインでは、`/etc/nixos` 配下に設置された現プロジェクト（通称: NixOS設定リポジトリ）の構成や考え方、通常使用されるコマンドやパッケージ等が記述されています。

## プロジェクト構成・モジュール

- `flake.nix`, `flake.lock`: フレークの入力/出力。エントリポイント。
- `hosts/<host>/configuration.nix`: マシン別 NixOS モジュール（例: `hosts/crown`）。
- `hosts/<host>/users/<user>/default.nix`: ユーザー別 Home Manager。共通処理は `users/common.nix`。
- `templates/<language>`: 言語別シェル環境サンプル（例: `templates/node`, `templates/python`）。`nix develop ...`で実行
- `hosts/<host>/archive.sh`, `cleanup.sh`:補助スクリプト（cron 実行）。

## ビルド・テスト・開発

- フォーマット: `nix fmt`
- ビルド: `sudo nixos-rebuild build --flake .#<host>`
- 反映: `sudo nixos-rebuild switch --flake .#<host>`
