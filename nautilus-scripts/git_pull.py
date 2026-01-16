from gi.repository import Nautilus, GObject
import subprocess
import urllib.parse
import os

SCRIPTS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "scripts")
GIT_PULL_SCRIPT = os.path.join(SCRIPTS_DIR, "git-pull.sh")


class GitPullExtension(GObject.GObject, Nautilus.MenuProvider):

    def _run_in_terminal(self, script_path, args):
        """Run a script in gnome-terminal"""
        cmd = f'"{script_path}" {args}; echo ""; read -p "Press Enter to close..."'
        subprocess.Popen([
            "gnome-terminal",
            "--",
            "bash", "-c", cmd
        ])

    def _pull_this_repo(self, menu, folder):
        path = urllib.parse.unquote(folder.get_uri()[7:])
        self._run_in_terminal(GIT_PULL_SCRIPT, f'"{path}"')

    def _pull_all_repos(self, menu, folder):
        path = urllib.parse.unquote(folder.get_uri()[7:])
        self._run_in_terminal(GIT_PULL_SCRIPT, f'"{path}" --recursive')

    def get_file_items(self, window, files):
        # Only show for single folder selection
        if len(files) != 1:
            return

        folder = files[0]
        if not folder.is_directory():
            return

        path = urllib.parse.unquote(folder.get_uri()[7:])

        # Create main menu item
        main_item = Nautilus.MenuItem(
            name="GitPullExtension::GitPull",
            label="Git Pull",
            tip="Pull latest changes from remote",
            icon="git"
        )

        # Create submenu
        submenu = Nautilus.Menu()
        main_item.set_submenu(submenu)

        # Check if selected folder is a git repo
        is_git_repo = os.path.isdir(os.path.join(path, ".git"))

        # Option 1: This repo (only if it's a git repo)
        if is_git_repo:
            item_this = Nautilus.MenuItem(
                name="GitPullExtension::ThisRepo",
                label="This repo",
                tip="Pull this repository",
                icon="git"
            )
            item_this.connect("activate", self._pull_this_repo, folder)
            submenu.append_item(item_this)

        # Option 2: All repos inside
        item_all = Nautilus.MenuItem(
            name="GitPullExtension::AllRepos",
            label="All repos inside",
            tip="Pull all repositories inside this folder",
            icon="git"
        )
        item_all.connect("activate", self._pull_all_repos, folder)
        submenu.append_item(item_all)

        return [main_item]
