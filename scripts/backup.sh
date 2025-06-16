#!/bin/bash

cd
echo "--- Starting backup ---"
rsync -ravzX --delete --exclude '*.log' --exclude '*.tgz' --exclude '*.log.gz' --exclude '*.mp4' --exclude '*.tar.gz' --exclude '*must-gather*' --exclude '*sosreport*' --exclude 'go*' $(find . -maxdepth 1 -type f) Documents Downloads zsh-* bin scripts backup
rsync -ravzX --delete ./.config/sublime-text-3/Local/Session.sublime_session backup
rsync -ravzX --delete .zsh* .vim* .vim/ zsh-* .ssh* .oh-my-zsh .oc* .tmux* .aws* .aws/ .config/sublime-text-3/ .config/ocm-container .oh-my-bash .bash* .fzf* .shell* .config/obs-studio .config/backplane .config/pagerduty-cli .config/osdctl core
rsync -ravzX --delete .gitconfig .git-prompt.sh .p10k.zsh .profile .pki core
rsync -ravzX --delete go/bin core/go/bin
dnf history userinstalled > backup/user-installed-rpm-$(date +%d-%m-%Y).txt
cd /home/travi/go/src/github.com/ravitri;
for i in `ls -1`; do cd $i > /dev/null; git config --get remote.origin.url ;cd - > /dev/null; done | tee /home/travi/backup/ravitri-repos-$(date +%d-%m-%Y).txt
cd /home/travi
echo "--- Backup finished. Starting tar.gz ---"
tar cf backup-$(date +%d-%m-%Y).tar backup
gzip -9 backup-$(date +%d-%m-%Y).tar
tar cf core-$(date +%d-%m-%Y).tar core
gzip -9 core-$(date +%d-%m-%Y).tar

echo "--- All done ! ---"
