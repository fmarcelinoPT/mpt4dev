from gi.repository import Nautilus, GObject
import subprocess
import urllib.parse
import os

SCRIPTS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "scripts")
GIT_SWITCH_SCRIPT = os.path.join(SCRIPTS_DIR, "git-switch.sh")


class GitSwitchBranchExtension(GObject.GObject, Nautilus.MenuProvider):

    def _run_in_terminal(self, script_path, args):
        """Run a script in gnome-terminal"""
        cmd = f'"{script_path}" {args}; echo ""; read -p "Press Enter to close..."'
        subprocess.Popen([
            "gnome-terminal",
            "--",
            "bash", "-c", cmd
        ])

    def _ask_branch_and_switch(self, path, recursive):
        """Use zenity to ask for branch name, then switch"""
        try:
            result = subprocess.run([
                "zenity",
                "--entry",
                "--title=Git Switch Branch",
                "--text=Enter branch name:",
                "--entry-text=",
            ], capture_output=True, text=True)

            if result.returncode == 0 and result.stdout.strip():
                branch = result.stdout.strip()
                args = f'"{path}" "{branch}"'
                if recursive:
                    args += " --recursive"
                self._run_in_terminal(GIT_SWITCH_SCRIPT, args)
        except FileNotFoundError:
            # Zenity not installed, show error
            subprocess.Popen([
                "gnome-terminal",
                "--",
                "bash", "-c",
                'echo "Error: zenity is not installed. Please install it with: sudo dnf install zenity"; read -p "Press Enter to close..."'
            ])

    def _switch_this_repo(self, menu, folder, branch):
        path = urllib.parse.unquote(folder.get_uri()[7:])
        self._run_in_terminal(GIT_SWITCH_SCRIPT, f'"{path}" "{branch}"')

    def _switch_all_repos(self, menu, folder, branch):
        path = urllib.parse.unquote(folder.get_uri()[7:])
        self._run_in_terminal(GIT_SWITCH_SCRIPT, f'"{path}" "{branch}" --recursive')

    def _switch_this_repo_custom(self, menu, folder):
        path = urllib.parse.unquote(folder.get_uri()[7:])
        self._ask_branch_and_switch(path, recursive=False)

    def _switch_all_repos_custom(self, menu, folder):
        path = urllib.parse.unquote(folder.get_uri()[7:])
        self._ask_branch_and_switch(path, recursive=True)

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
            name="GitSwitchBranchExtension::GitSwitch",
            label="Git Switch Branch",
            tip="Switch to a branch and pull",
            icon="git"
        )

        # Create submenu
        submenu = Nautilus.Menu()
        main_item.set_submenu(submenu)

        # Check if selected folder is a git repo
        is_git_repo = os.path.isdir(os.path.join(path, ".git"))

        # Predefined branches
        branches = ["main", "develop"]

        for branch in branches:
            if is_git_repo:
                # Option: branch (this repo)
                item_this = Nautilus.MenuItem(
                    name=f"GitSwitchBranchExtension::{branch}This",
                    label=f"{branch} (this repo)",
                    tip=f"Switch this repo to {branch}",
                    icon="git"
                )
                item_this.connect("activate", self._switch_this_repo, folder, branch)
                submenu.append_item(item_this)

            # Option: branch (all repos inside)
            item_all = Nautilus.MenuItem(
                name=f"GitSwitchBranchExtension::{branch}All",
                label=f"{branch} (all repos inside)",
                tip=f"Switch all repos inside to {branch}",
                icon="git"
            )
            item_all.connect("activate", self._switch_all_repos, folder, branch)
            submenu.append_item(item_all)

        # Separator (using a disabled menu item as separator)
        separator = Nautilus.MenuItem(
            name="GitSwitchBranchExtension::Separator",
            label="────────────────────",
            tip="",
        )
        separator.set_property("sensitive", False)
        submenu.append_item(separator)

        # Custom branch options
        if is_git_repo:
            item_custom_this = Nautilus.MenuItem(
                name="GitSwitchBranchExtension::CustomThis",
                label="Other branch... (this repo)",
                tip="Switch this repo to a custom branch",
                icon="git"
            )
            item_custom_this.connect("activate", self._switch_this_repo_custom, folder)
            submenu.append_item(item_custom_this)

        item_custom_all = Nautilus.MenuItem(
            name="GitSwitchBranchExtension::CustomAll",
            label="Other branch... (all repos inside)",
            tip="Switch all repos inside to a custom branch",
            icon="git"
        )
        item_custom_all.connect("activate", self._switch_all_repos_custom, folder)
        submenu.append_item(item_custom_all)

        return [main_item]
