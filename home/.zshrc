eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FLUTTER_HOME="$HOME/Developer/flutter"
export PATH="$PATH:$HOME/.local/bin:$FLUTTER_HOME/bin"

export EDITOR=nvim

. "$HOME/.cargo/env"


## INTERACTIVE ONLY

[[ -o interactive ]] || return


cd "$HOME/Developer"
set -o emacs

alias cdd="cd $HOME/Developer"
alias g="gitui"

# Takes filename and returns the amount of seconds since it has
# been modified
function elapsed() {
	filename=$1
	mtime=$(stat -f %m $filename)
	now=$(date +%s)

	(( elapsed = $now - $mtime ))

	echo $elapsed
}

LLAMABARN_CACHE=/tmp/llamabarn-model


# Get the most recently insalled model from LlamaBarn and export it
# to be used from NeoVim
if [[ -f $LLAMABARN_CACHE && $(elapsed $LLAMABARN_CACHE) -lt 3600 ]]; then
	export LLAMACPP_MODEL=$(cat $LLAMABARN_CACHE)
elif models=$(curl -s http://localhost:2276/v1/models); then
	model=$(jq -r ".data | max_by(.created).id" <<< "$models")
	
	export LLAMACPP_MODEL=$model
	echo $model > $LLAMABARN_CACHE
fi

REAL_NPM=$(command -v npm)

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
