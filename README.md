# 多田研究室 NixOS構成

## 適用方法

1. `/etc/nixos` にクローン
2. `sudo nixos-rebuild switch --flake /etc/nixos#<ホスト名>` で設定を適用

## ファイル構成

- `flake.nix` / `flake.lock`: Flake のエントリポイントとピン留め
- `hosts/<ホスト名>/configuration.nix`: ホスト別 NixOS モジュール（例: `hosts/crown/configuration.nix`）
- `hosts/<ホスト名>/users/common.nix`: ユーザー設定の共通項目
- `hosts/<ホスト名>/users/<ユーザー名>/default.nix`: ユーザー別設定
- `templates/<言語名>`: 言語別の開発用テンプレート（例: `templates/python`）

## ホスト追加

1. `hosts/<新規ホスト名>/configuration.nix` を用意
2. `hosts/<新規ホスト名>/users/<新規ユーザー名>/default.nix` を作成（共通処理は `../common.nix` を `import`）
3. 以後 `sudo nixos-rebuild switch --flake /etc/nixos#<新規ホスト名>` で反映される

## 開発環境セットアップ

### Python

1. `nix flake new <プロジェクト> -t /etc/nixos/templates#python` で `./<プロジェクト>` にプロジェクトが初期化される
2. `cd <プロジェクト>` でプロジェクトディレクトリに移動
3. `nix develop .#<Pythonバージョン>.<CUDAバージョン>` で指定`<Pythonバージョン>`/`<CUDAバージョン>`がセットアップされた環境のシェルに入れる（CUDAを使用しない場合は`<CUDAバージョン>`に`default`を入れる）

例（`~/Code`にいる場合において`~/Code/llmtest`にPython 3.9 / CUDA 12.1の環境をセットアップ）:

```
nix flake new llmtest -t /etc/nixos/templates#python
cd ./llmtest
nix develop .#python39.cu121 # CUDAを使用しない場合は nix develop .#python39.default を実行
```

### NodeJS

1. `nix flake new <プロジェクト> -t /etc/nixos/templates#node` で `./<プロジェクト>` にプロジェクトが初期化される
2. `cd <プロジェクト>` でプロジェクトディレクトリに移動
3. `nix develop .#<NodeJSバージョン>` で指定`<NodeJSバージョン>`がセットアップされた環境のシェルに入れる

例（`~/Code`にいる場合において`~/Code/webapp`にNodeJS 22の環境をセットアップ）:

```
nix flake new webapp -t /etc/nixos/templates#node
cd ./webapp
nix develop .#node22
```
