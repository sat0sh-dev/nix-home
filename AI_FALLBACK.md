# AI Fallback System - セットアップと運用ガイド

## 概要

Claude Codeのrate limit/usage limit発生時に、自動的にOllama + aiderへフォールバックするシステムです。

### 設計思想

- **Claude Codeが常に第一候補**: 最高品質のコード生成
- **自動フォールバック**: rate limit時のみOllama + aiderに切り替え
- **透明性**: どちらのAIが実行されているか常に可視化
- **文脈の永続化**: README.md、CLAUDE.md、git historyを真の記憶とする

### 対応プラットフォーム

**⚠️ Linux（home-dev）専用**

- macOSはメモリ不足のため非対応
- x86_64-linux環境で動作確認済み

---

## セットアップ手順

### 1. Home Manager設定の適用

```bash
# nix-homeディレクトリに移動
cd ~/nix-home

# home-dev構成を適用
nix run home-manager/master -- switch --flake .#home-dev --impure
```

この操作で以下がインストールされます：
- `ollama` - ローカルLLMランタイム
- `aider-chat` - AIペアプログラミングツール
- `ai-code` - ラッパーCLI（自動フォールバック機能付き）

### 2. Ollamaモデルのインストール

初回のみ、使用するLLMモデルをダウンロードする必要があります：

```bash
# 推奨: DeepSeek Coder（高品質、中サイズ）
ollama pull deepseek-coder:6.7b

# 代替1: Qwen2.5 Coder（バランス型）
ollama pull qwen2.5-coder:7b

# 代替2: CodeLlama（軽量）
ollama pull codellama:7b
```

**推奨モデル**: `deepseek-coder:6.7b`
- 理由: コード生成品質とメモリ使用量のバランスが良い
- メモリ: 約8GB RAM必要

### 3. Ollamaサーバーの起動

aiderを使う前にOllamaサーバーを起動してください：

```bash
# バックグラウンドで起動
ollama serve &

# 確認
ollama list
```

### 4. aiderの初期設定

初回起動時にaiderの設定を行います：

```bash
# aiderを起動して設定
aider

# プロンプトで以下を選択：
# - Model: ollama/deepseek-coder:6.7b
# - Editor: vim（またはお好みのエディタ）
```

設定は `~/.aider.conf.yml` に保存されます。

---

## 使用方法

### 基本的な使い方

```bash
# ai-codeコマンドを使う（常にこれを使用）
ai-code "この関数をリファクタして"
```

### 動作フロー

1. **Claude Code実行**:
   ```
   [AI: Claude Code]
   ... 出力 ...
   ```

2. **rate limit時（自動フォールバック）**:
   ```
   [AI: Ollama + Aider (fallback - rate limit detected)]
   ... Ollamaによる出力 ...
   ```

3. **次回実行時（自動復帰）**:
   - 再び Claude Code を試行
   - 成功すれば Claude Code に復帰
   - 失敗すれば再度 aider にフォールバック

### 文脈の提供

ai-codeは以下のファイルを自動的にaiderに渡します：
- `CLAUDE.md` - プロジェクトのAI作業契約
- `README.md` - プロジェクト概要

**推奨**: 作業前に必ず以下を更新してください：
```bash
# CLAUDE.mdに現在の作業内容を記載
vim CLAUDE.md

# git diffで変更を確認
git diff

# commitで文脈を記録
git commit -m "作業内容の説明"
```

### 対話的な作業

ai-codeは単発プロンプト専用です。対話的な作業には：

```bash
# Claude Code（インタラクティブモード）
claude

# aider（インタラクティブモード）
aider
```

---

## 環境変数

### OLLAMA_KEEP_ALIVE

**デフォルト**: `5m`

Ollamaが推論終了後、モデルをメモリに保持する時間：
- `5m`: 5分後にメモリ解放（推奨）
- `0`: 即座に解放（頻繁に使う場合は遅い）
- `24h`: 24時間保持（メモリ潤沢な場合）

変更方法（`home-dev.nix`）:
```nix
home.sessionVariables = {
  OLLAMA_KEEP_ALIVE = "10m";  # 10分に変更
};
```

---

## トラブルシューティング

### 1. `ai-code: command not found`

**原因**: Home Manager設定が適用されていない

**解決**:
```bash
cd ~/nix-home
nix run home-manager/master -- switch --flake .#home-dev --impure
```

### 2. `aider: Failed to connect to ollama`

**原因**: Ollamaサーバーが起動していない

**解決**:
```bash
# Ollamaを起動
ollama serve &

# 確認
curl http://localhost:11434/api/tags
```

### 3. `ollama: model not found`

**原因**: モデルがインストールされていない

**解決**:
```bash
ollama pull deepseek-coder:6.7b
```

### 4. Claude Codeのrate limitが頻発する

**原因**: API利用量が上限に達している

**対処**:
1. 一時的にaiderを直接使用:
   ```bash
   aider --message "作業内容"
   ```

2. 時間を置いてから再試行（通常1時間後にリセット）

3. Claude API tierの確認:
   ```bash
   claude --help  # API情報の確認方法を表示
   ```

### 5. aiderの出力品質が低い

**原因**: Ollamaモデルの能力限界

**対処**:
1. より大きなモデルを試す:
   ```bash
   ollama pull deepseek-coder:33b  # 高品質だがメモリ大量消費
   ```

2. Claude Code復帰まで待つ（rate limit解除）

3. 簡単なタスクのみaiderに任せる:
   - ✅ 小規模なリファクタリング
   - ✅ 既存コードの微修正
   - ✅ コメント追加
   - ❌ 大規模な新機能実装
   - ❌ 複雑なアルゴリズム設計

---

## 制限事項と注意点

### システムの制限

1. **文脈の断絶**: Claude CodeとaiderはセッションHistory履歴を共有しない
   - 対策: git commitとCLAUDE.mdで文脈を記録

2. **品質の差**: Ollamaのコード生成品質はClaude Code（Sonnet 4.5）より劣る
   - 対策: 重要な実装はClaude Code復帰まで待つ

3. **メモリ消費**: Ollamaは推論時に大量のRAMを使用
   - 対策: OLLAMA_KEEP_ALIVE=5mで非使用時は解放

### 運用のベストプラクティス

1. **CLAUDE.mdの更新**:
   ```bash
   # 作業開始前
   vim CLAUDE.md  # 現在のタスクを記載

   # 作業終了後
   git add CLAUDE.md
   git commit -m "Update work context"
   ```

2. **小刻みなcommit**:
   ```bash
   # 機能単位でcommit
   git commit -m "Add user authentication"
   git commit -m "Fix validation bug"
   ```

3. **フォールバック時の確認**:
   - aiderの出力を必ず目視確認
   - テストを実行して品質を担保

4. **Claude Code優先の徹底**:
   - rate limit解除後は必ずClaude Codeを試す
   - aiderの常用は避ける

---

## 高度な設定

### systemd user serviceでOllamaを管理（オプション）

常時Ollamaを使う場合、systemd管理が便利です：

**1. サービスファイル作成**:
```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/ollama.service <<'EOF'
[Unit]
Description=Ollama LLM Server
After=network.target

[Service]
Type=simple
ExecStart=/home/%u/.nix-profile/bin/ollama serve
Environment="OLLAMA_KEEP_ALIVE=5m"
Restart=on-failure

[Install]
WantedBy=default.target
EOF
```

**2. サービス有効化**:
```bash
systemctl --user daemon-reload
systemctl --user enable ollama
systemctl --user start ollama
```

**3. 状態確認**:
```bash
systemctl --user status ollama
```

### aiderの設定カスタマイズ

`~/.aider.conf.yml`:
```yaml
model: ollama/deepseek-coder:6.7b
edit-format: diff
auto-commits: false
dark-mode: true
```

---

## 参考情報

### 使用しているツール

- **Claude Code**: https://claude.ai/code
- **Ollama**: https://ollama.ai/
- **aider**: https://aider.chat/

### 推奨モデル

| モデル | サイズ | メモリ | 品質 | 用途 |
|--------|--------|--------|------|------|
| deepseek-coder:6.7b | 6.7B | 8GB | ⭐⭐⭐⭐ | 推奨（バランス型） |
| qwen2.5-coder:7b | 7B | 8GB | ⭐⭐⭐⭐ | 代替（高速） |
| deepseek-coder:33b | 33B | 32GB | ⭐⭐⭐⭐⭐ | 高品質（要大容量メモリ） |
| codellama:7b | 7B | 8GB | ⭐⭐⭐ | 軽量（品質やや低い） |

---

## アップデート履歴

- **2025-01-05**: Phase 1実装完了（基本的なフォールバック機能）
- **今後の予定**: Phase 2（運用改善）、Phase 3（統合機能）

---

**問題が解決しない場合**: `~/nix-home/AI_FALLBACK.md`を確認するか、システム管理者に連絡してください。
