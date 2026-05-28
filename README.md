# Claude Codex Pipeline for cmux

一个基于 cmux 的本地开发流程工具，用来把 Claude Code 和 Codex 串成三阶段流水线：

1. Claude Code 生成架构计划。
2. Codex 根据计划实现代码。
3. Claude Code 对实现结果进行审核。

执行入口：

```bash
claude-codex-pipeline-cmux [--mode exec|tui] "<任务描述>"
```

## 环境要求

需要安装并登录：

- cmux
- Claude Code CLI，命令为 `claude`
- Codex CLI，命令为 `codex`

还需要：

- `python3`
- `git`
- `realpath`
- 常见 Unix 命令：`bash`、`find`、`grep`、`head`、`tee`、`sed`、`cut`、`sleep`

可选：

- Google Chrome 或系统默认浏览器。当前项目目录存在 `index.html` 时，脚本会尝试自动打开预览。

## 安装

克隆仓库：

```bash
git clone https://github.com/wyhAcc/claude-codex-pipeline-cmux.git
cd claude-codex-pipeline-cmux
```

执行安装脚本：

```bash
./install.sh
```

`install.sh` 的作用很简单：

- 给主脚本添加执行权限。
- 检查 `claude`、`codex`、`python3`、`git` 是否可用，并打印版本。
- 输出把当前项目目录加入 `PATH` 的命令。

把当前项目目录加入 `PATH`：

```bash
export PATH="$(pwd):$PATH"
```

如果希望永久生效，可以把当前项目的绝对路径写入 shell 配置。例如 zsh：

```bash
echo "export PATH=\"$(pwd):\$PATH\"" >> ~/.zshrc
```

## 快速使用

从 cmux 的终端或会话里，进入你希望 Codex 修改的项目目录：

```bash
cd /path/to/project
git status
claude-codex-pipeline-cmux --mode exec "实现一个静态 Todo 页面"
```

建议给任务描述加引号。脚本支持多词任务描述，但加引号可以避免 shell 解析造成歧义。

运行结束后查看结果：

```bash
git diff
```

终端会打印 review 文件路径，通常是：

```text
/tmp/pipeline-review-<pid>.md
```

建议先阅读 review 文件，再检查 `git diff`，确认没问题后再提交代码。

## 执行模式

`exec` 模式会让 Codex 自动执行，Codex 退出后自动进入 Claude Code 审核：

```bash
claude-codex-pipeline-cmux --mode exec "根据 README.md 实现功能"
```

`tui` 模式会在 cmux 分屏里打开 Codex 交互界面：

```bash
claude-codex-pipeline-cmux --mode tui "重构 dashboard 页面"
```

在 `tui` 模式下，Codex 完成实现后，需要在 Codex 里输入：

```text
/exit
```

这样才会进入 Claude Code 审核阶段。

如果不传 `--mode`，并且当前 stdin 是交互式终端，脚本会询问选择 `exec` 还是 `tui`。

## Preflight 检查

每次启动 pipeline 前，脚本都会检查：

- cmux 是否安装并可执行。
- 当前 shell 是否能被 cmux 识别。
- `claude` 和 `codex` 是否安装且可用。
- `python3`、`git` 和基础 shell 命令是否存在。
- 当前目录是否是 git 仓库。

如果 cmux 安装在非默认位置，可以通过 `CMUX` 指定：

```bash
CMUX=/path/to/cmux claude-codex-pipeline-cmux --mode exec "实现一个静态 Todo 页面"
```

## Git 使用建议

真实项目建议在 git 仓库里运行：

```bash
cd /path/to/project
git status
claude-codex-pipeline-cmux --mode exec "你的任务"
git diff
```

推荐流程：

1. 从干净的 working tree 开始。
2. 运行 pipeline。
3. 阅读终端最后打印的 review 文件。
4. 检查 `git diff`。
5. 人工确认后再提交。

如果当前目录不是 git 仓库，`exec` 模式会使用 `--skip-git-repo-check`。在 `tui` 模式下，脚本可能会执行 `git init`，因为交互式 Codex 更依赖 git 仓库上下文。

## 输出文件

每次运行会生成临时文件：

- 计划文件：`/tmp/pipeline-plan-<pid>.md`
- 审核文件：`/tmp/pipeline-review-<pid>.md`

审核阶段结束后，终端会输出简短的 PASS/WARN/FAIL 摘要。

## 安全注意事项

- 只在允许 Codex 写入的目录运行。
- 不要在包含密钥、客户数据、生产专用配置的目录里直接运行，除非这些内容可以安全发送给 Claude/Codex。
- 脚本会把目录列表、文件树摘要、diff 和文件片段发送给 Claude/Codex。
- 提交或发布前必须人工 review 生成的代码。

## 常见问题

`cmux is installed but this shell is not identifiable by cmux`

请从 cmux 终端或 cmux 会话里运行命令。

`claude CLI is installed but not usable`

检查 Claude Code 是否安装、是否在 `PATH` 上，以及是否已经登录。

`codex CLI is installed but not usable`

检查 Codex 是否安装、是否在 `PATH` 上，以及是否已经登录。

`Current directory is not a git repo`

这是 `exec` 模式下的提示。正式使用时建议先初始化 git：

```bash
git init
git add .
git commit -m "initial state"
```
