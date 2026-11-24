#!/usr/bin/env bash
#
# Back up home-directory files and dotfiles into ~/backup and ~/core,
# then create compressed archives of both.
#
# Configurable through environment variables:
#   BACKUP_DIR  destination for regular files      (default: ~/backup)
#   CORE_DIR    destination for dotfiles/config    (default: ~/core)
#   REPOS_DIR   directory of git checkouts whose remote URLs are recorded
#               (default: unset, step skipped)
#   KEEP        number of archives of each kind to keep; 0 keeps all (default: 0)
#
# NOTE: the "core" archive contains SSH keys and cloud credentials.
# Archives are created with mode 600; consider encrypting them
# (e.g. `gpg -c core-<date>.tar.gz`) before copying them off this machine.

set -euo pipefail
shopt -s nullglob

BACKUP_DIR="${BACKUP_DIR:-$HOME/backup}"
CORE_DIR="${CORE_DIR:-$HOME/core}"
REPOS_DIR="${REPOS_DIR:-}"
KEEP="${KEEP:-0}"
today=$(date +%d-%m-%Y)

RSYNC_OPTS=(-aX --delete)
EXCLUDES=(
  --exclude '*.log' --exclude '*.log.gz'
  --exclude '*.tgz' --exclude '*.tar.gz'
  --exclude '*.mp4'
  --exclude '*must-gather*' --exclude '*sosreport*'
  --exclude '/go*'   # only top-level go* entries, not every nested match
)

log() { echo "--- $* ---"; }

# sync_to DEST PATH... : rsync the given paths into DEST, skipping any that
# do not exist so a missing optional dotfile does not abort the backup.
sync_to() {
  local dest=$1; shift
  local src=() p
  for p in "$@"; do
    [[ -e $p ]] && src+=("$p")
  done
  if (( ${#src[@]} == 0 )); then
    echo "nothing to sync into $dest"
    return 0
  fi
  rsync "${RSYNC_OPTS[@]}" "${EXCLUDES[@]}" "${src[@]}" "$dest"
}

cd "$HOME"
mkdir -p "$BACKUP_DIR" "$CORE_DIR/go/bin"

log "Starting backup"

# Regular files and directories -> $BACKUP_DIR
mapfile -d '' top_files < <(find . -maxdepth 1 -type f -print0)
sync_to "$BACKUP_DIR/" "${top_files[@]}" Documents Downloads zsh-* bin scripts
sync_to "$BACKUP_DIR/" .config/sublime-text-3/Local/Session.sublime_session

# Dotfiles and tool configuration -> $CORE_DIR
# Edit these lists to match the tools you use; missing paths are skipped.
# (no trailing slashes: "dir/" would copy the directory's contents
#  straight into $CORE_DIR instead of the directory itself)
sync_to "$CORE_DIR/" \
  .zsh* .vim* .ssh* .oh-my-zsh .oc* .tmux* .aws* \
  .config/sublime-text-3 .config/ocm-container .oh-my-bash .bash* .fzf* \
  .shell* .config/obs-studio .config/backplane .config/pagerduty-cli \
  .config/osdctl
sync_to "$CORE_DIR/" .gitconfig .git-prompt.sh .p10k.zsh .profile .pki

if [[ -d go/bin ]]; then
  rsync "${RSYNC_OPTS[@]}" go/bin/ "$CORE_DIR/go/bin/"
fi

# List of user-installed packages
if command -v dnf > /dev/null; then
  dnf history userinstalled > "$BACKUP_DIR/user-installed-rpm-$today.txt"
fi

# Remote URLs of local git checkouts
if [[ -n $REPOS_DIR && -d $REPOS_DIR ]]; then
  for repo in "$REPOS_DIR"/*/; do
    git -C "$repo" config --get remote.origin.url || true
  done | tee "$BACKUP_DIR/git-repos-$today.txt"
else
  echo "skipping repo list: REPOS_DIR not set or not a directory"
fi

log "Backup finished. Creating archives"

umask 077
for dir in "$BACKUP_DIR" "$CORE_DIR"; do
  name=$(basename "$dir")
  tar -cf - -C "$(dirname "$dir")" "$name" | gzip -9 > "$HOME/$name-$today.tar.gz"
  echo "created $HOME/$name-$today.tar.gz"

  if (( KEEP > 0 )); then
    # Archive names contain no whitespace, so ls -t is safe here.
    # shellcheck disable=SC2012
    ls -1t "$HOME/$name"-*.tar.gz | tail -n +$((KEEP + 1)) | xargs -r rm -v --
  fi
done

log "All done!"
