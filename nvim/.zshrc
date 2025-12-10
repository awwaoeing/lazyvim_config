# ==================== 平台检测 ====================
# 此配置文件支持 macOS 和 Linux (Ubuntu) 跨平台使用
# 检测操作系统类型，用于后续平台特定配置
if [[ "$OSTYPE" == "darwin"* ]]; then
    export IS_MACOS=1
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export IS_LINUX=1
fi

# ==================== 基础环境 ====================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
export CONDA_ROOT="$HOME/conda"
export PATH="$CONDA_ROOT/bin:$PATH"
export PATH="$HOME/my-config/bin:$PATH"

# Oh-My-Zsh 安装路径
export ZSH="$HOME/.oh-my-zsh"

# Vim 配置
# 不再使用 VIMINIT 环境变量,改用别名方式
# vim 使用 ~/my-config/.vimrc
# Neovim 使用 ~/.config/nvim/ 中的 LazyVim 配置
export VIMINIT=""  # 清空 VIMINIT 环境变量(覆盖系统级设置)

export COC_CONFIG_HOME="$HOME/my-config"
export MYSQL_HOME="$HOME/my-config"

# ==================== 别名 ====================
alias vim='vim -u $HOME/my-config/.vimrc'
alias g++='g++ -std=c++11'
alias h="$HOME/my-config/server_connect.sh"
alias make='make -j$(nproc)'
alias tmux='tmux -f "$HOME/my-config/.tmux/.tmux.conf"'
alias lazygit='LANG=en_US.UTF-8 lazygit'

# ==================== 平台特定别名 ====================
# ls 彩色支持（macOS 和 Linux 参数不同）
if [[ -n "$IS_MACOS" ]]; then
    alias ls='ls -G'
    alias ll='ls -lh -G'
    alias la='ls -lAh -G'
    alias mysql='mysql --socket=/var/run/mysqld/mysqld.sock'
elif [[ -n "$IS_LINUX" ]]; then
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lAh --color=auto'
    alias mysql='mysql --socket=/run/mysqld/mysqld.sock'  # Ubuntu 默认路径
fi

# ==================== 插件自动安装 ====================
ZSH_AUTOSUGGEST_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
[[ ! -d "$ZSH_AUTOSUGGEST_DIR" ]] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"

ZSH_SYNTAX_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
[[ ! -d "$ZSH_SYNTAX_DIR" ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"

CONDA_ZSH_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/conda-zsh-completion"
[[ ! -d "$CONDA_ZSH_DIR" ]] && git clone https://github.com/esc/conda-zsh-completion.git "$CONDA_ZSH_DIR"

plugins=(
  git
  z
  zsh-autosuggestions
  conda-zsh-completion
  zsh-syntax-highlighting
)




# ==================== 主题 ====================
ZSH_THEME="risto"

# 加载 Oh-My-Zsh
source $ZSH/oh-my-zsh.sh




# ==================== 补全系统优化（放在这里！）====================
# 1. 重新初始化补全系统（使用缓存）
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit -d ~/.zcompdump
done
compinit -C -d ~/.zcompdump

# 2. 启用补全缓存
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# 3. 忽略系统目录（核心优化）
zstyle ':completion:*:*:*:*:*' ignored-patterns \
    '/System/*' \
    '/Library/*' \
    '/Applications/*' \
    '/private/*' \
    '/usr/libexec/*' \
    '/usr/share/*' \
    '/var/*' \
    '/tmp/*'

# 4. 限制补全结果数量
zstyle ':completion:*' list-max-items 50
zstyle ':completion:*' menu select

# 5. 禁用自动纠错
unsetopt correct_all
unsetopt correct

















# ==================== zsh-autosuggestions 配置 ====================
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# 大小写不敏感
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 接受建议的快捷键（用l来补全）
bindkey ';' autosuggest-accept

# ==================== zsh-syntax-highlighting 配置 ====================
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=magenta'


# ==================== Prompt 配置====================
autoload -U colors && colors

# Conda 环境提示
conda_prompt_info() {
  [[ -n "$CONDA_DEFAULT_ENV" ]] && echo "%F{#ff9500}%B($CONDA_DEFAULT_ENV)%b%f "
}

# 方案B：只显示分支（最简单最快）
simple_git_info() {
  local branch=$(git branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && echo "%F{blue}($branch)%f"
}


# 或者使用 simple_git_info（只显示分支，更快）
PROMPT='$(conda_prompt_info)%F{#00d4ff}%B%n@%m%b%f %F{#00ffcc}%B%~%b%f %F{#ff007f}%B$(simple_git_info)%b%f
%F{#00ff88}%B❯%b%f '

setopt PROMPT_SUBST
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
unsetopt BEEP


# ==================== 自定义环境 ====================
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# ==================== UV 虚拟环境自动激活 ====================
# 自动激活/停用 uv 创建的虚拟环境（.venv）
autoload -U add-zsh-hook

# 查找虚拟环境目录（向上查找）
_find_venv() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.venv" ]]; then
            echo "$dir/.venv"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# 目录切换时的钩子函数
_auto_activate_venv() {
    local venv_path=$(_find_venv)

    # 如果找到虚拟环境
    if [[ -n "$venv_path" ]]; then
        # 如果当前未激活该虚拟环境
        if [[ "$VIRTUAL_ENV" != "$venv_path" ]]; then
            # 先停用已有的虚拟环境
            [[ -n "$VIRTUAL_ENV" ]] && deactivate 2>/dev/null
            # 激活新的虚拟环境
            source "$venv_path/bin/activate"
        fi
    else
        # 如果没找到虚拟环境，但当前有激活的虚拟环境，则停用
        if [[ -n "$VIRTUAL_ENV" ]]; then
            deactivate 2>/dev/null
        fi
    fi
}

# 注册钩子
add-zsh-hook chpwd _auto_activate_venv

# 在 shell 启动时也执行一次（用于新开终端时）
_auto_activate_venv


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# 修改为使用 $CONDA_ROOT 变量，以支持跨平台
__conda_setup="$('$CONDA_ROOT/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
        . "$CONDA_ROOT/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_ROOT/bin:$PATH"
    fi
fi
unset __conda_setup

# <<< conda initialize <<<

#conda activate myenv


export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

