# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/timothydavis/.zsh/completions:"* ]]; then export FPATH="/Users/timothydavis/.zsh/completions:$FPATH"; fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FLUTTER_HOME="$HOME/Developer/flutter"
export PATH="$PATH:$HOME/.local/bin:$FLUTTER_HOME/bin"

export EDITOR=nvim
export MISE_PYTHON_UV_VENV_AUTO="source"

export LLAMA_SERVER_URL="http://localhost:2276"
export LLAMA_FIM_MODEL="qwen2.5-coder-1.5b-q8_0:Q8_0"
export LLAMA_INST_MODEL="bartowski/google_gemma-4-E4B-it-GGUF:Q4_K_M"

. "$HOME/.cargo/env"


## INTERACTIVE ONLY

[[ -o interactive ]] || return

eval "$(starship init zsh)"
eval "$(mise activate zsh)"

cd "$HOME/Developer"
set -o emacs

function cdd() {
	cd "$HOME/Developer/$1"
}
compdef '_path_files -/ -W ~/Developer' cdd

alias g="gitui"


function export_env_files() {
	export UV_ENV_FILE=""
	[[ -f ".env" ]] && export UV_ENV_FILE="$UV_ENV_FILE .env"
	[[ -f ".env.local" ]] && export UV_ENV_FILE="$UV_ENV_FILE .env.local"
}

add-zsh-hook precmd export_env_files

# Takes filename and returns the amount of seconds since it has
# been modified
function elapsed() {
	filename=$1
	mtime=$(stat -f %m $filename)
	now=$(date +%s)

	(( elapsed = $now - $mtime ))

	echo $elapsed
}

REAL_NPM=$(command -v npm)
alias npmr=$REAL_NPM

function npm() {
	if [ -f ".env.local" ]; then
		echo "Found .env.local, using dotenvx"
		dotenvx run -f ".env.local" -- $REAL_NPM $@
	else
		echo "No .env.local, using normal npm run"
		$REAL_NPM $@
	fi
}

function _nestgen1() {
	NAME="$1"
	npm run nest:g:mo $NAME
	npm run nest:g:s $NAME
	npm run nest:g:co $NAME
}

function nestgen() {
	[[ -f backend/package.json ]] || (echo "Not in project root?"; exit 1)
	for name in $@; do
		_nestgen1 $name
	done
}
. "/Users/timothydavis/.deno/env"
