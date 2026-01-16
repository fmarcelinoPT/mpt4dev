from gi.repository import Nautilus, GObject
import subprocess
import urllib.parse

class OpenWithVSCode(GObject.GObject, Nautilus.MenuProvider):

    def _open(self, menu, files):
        for f in files:
            path = urllib.parse.unquote(f.get_uri()[7:])
            subprocess.Popen(["code", path])

    def get_file_items(self, window, files):
        # Apenas mostrar para pastas
        if not all(f.is_directory() for f in files):
            return

        item = Nautilus.MenuItem(
            name="OpenWithVSCode::Open",
            label="Open in VS Code...",
            tip="Open selected folder in Visual Studio Code",
            icon="code"
        )

        item.connect("activate", self._open, files)
        return [item]
