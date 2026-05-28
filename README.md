# Claude Codex Pipeline for cmux

这是一个基于 cmux 的本地三阶段开发流程工具：

1. Claude Code 先生成架构计划。
2. Codex 根据计划在当前工作目录里实现代码。
3. Claude Code 再根据原始计划审核实现结果。

执行入口：

```bash
claude-codex-pipeline-cmux [--mode exec|tui] "<任务描述>"
```

## 安装

在本仓库目录下执行：

```bash
./install.sh
```

把当前项目目录加入 `PATH`：

```bash
export PATH="$(pwd):$PATH"
```

如果使用 zsh，并且希望永久生效，可以把当前项目的绝对路径写入 `~/.zshrc`：

```bash
echo "export PATH=\"$(pwd):\$PATH\"" >> ~/.zshrc
```

## 快速开始

1. 克隆仓库并进入目录：

```bash
git clone https://github.com/wyhAcc/claude-codex-pipeline-cmux.git
cd claude-codex-pipeline-cmux
```

2. 初始化命令权限：

```bash
./install.sh
```

3. 把项目目录加入 `PATH`：

```bash
export PATH="$(pwd):$PATH"
```

如果希望永久生效，把当前项目的绝对路径追加到 shell 配置里，例如 `~/.zshrc`：

```bash
echo "export PATH=\"$(pwd):\$PATH\"" >> ~/.zshrc
```

4. 安装并登录依赖 CLI，然后检查版本：

```bash
claude --version
codex --version
python3 --version
git --version
```

还需要单独安装 cmux。运行 pipeline 时必须从 cmux 的终端或会话里启动；如果当前 shell 不能被 cmux 识别，preflight 会直接失败。

5. 进入要修改的项目目录后运行：

```bash
cd /path/to/project
git status
claude-codex-pipeline-cmux --mode exec "实现一个静态 Todo 页面"
```

6. 如果想人工盯着 Codex 执行，使用交互模式：

```bash
claude-codex-pipeline-cmux --mode tui "重构 dashboard 页面"
```

在 `tui` 模式下，Codex 完成实现后，需要在 Codex 里输入：

```text
/exit
```

这样才会进入 Claude Code 审核阶段。

7. 查看结果：

```bash
git diff
```

运行结束后终端会打印 review 文件路径，通常是：

```text
/tmp/pipeline-review-<pid>.md
```

建议先阅读 review 文件，再检查 `git diff`，确认没问题后再提交代码。

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

- Google Chrome 或系统默认浏览器。只有当前项目目录存在 `index.html` 时才会用于自动预览。

## Preflight 检查

脚本启动前会检查：

- cmux 是否安装并可执行。
- 当前 shell 是否能被 cmux 识别。
- `claude` 和 `codex` 是否安装且可用。
- `python3`、`git` 和基础 shell 命令是否存在。
- 当前目录是否是 git 仓库。

如果 cmux 安装在非默认位置，可以通过 `CMUX` 指定：

```bash
CMUX=/path/to/cmux claude-codex-pipeline-cmux --mode exec "实现一个静态 Todo 页面"
```

## 使用方式

进入你希望 Codex 修改的项目目录后运行：

```bash
cd /path/to/project
claude-codex-pipeline-cmux --mode exec "根据 README.md 实现功能"
```

建议给任务描述加引号。脚本支持多词任务描述，但加引号可以避免 shell 解析造成歧义。

### 执行模式

`exec` 模式会让 Codex 自动执行，Codex 退出后自动进入 Claude Code 审核：

```bash
claude-codex-pipeline-cmux --mode exec "创建 index.html、style.css 和 app.js，实现一个计算器"
```

`tui` 模式会在 cmux 分屏里打开 Codex 交互界面。实现完成后，在 Codex 里输入 `/exit` 触发审核：

```bash
claude-codex-pipeline-cmux --mode tui "重构 dashboard 页面"
```

如果不传 `--mode`，并且当前 stdin 是交互式终端，脚本会询问选择 `exec` 还是 `tui`。

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
