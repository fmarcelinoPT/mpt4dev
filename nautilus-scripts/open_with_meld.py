from gi.repository import Nautilus, GObject
import subprocess
import urllib.parse

class CompareWithMeldExtension(GObject.GObject, Nautilus.MenuProvider):

    def _open_meld(self, menu, files):
        paths = []
        for f in files:
            # Convert URI (file:///...) to a proper filesystem path
            path = urllib.parse.unquote(f.get_uri()[7:])
            paths.append(path)

        subprocess.Popen(["meld"] + paths)

    def get_file_items(self, window, files):
        count = len(files)

        # Nothing selected → no menu
        if count == 0:
            return

        # Build menu entry label depending on selection
        if count == 1:
            label = "Open in Meld..."
        elif count == 2:
            label = "Compare in Meld"
        else:
            # More than two items: do not show anything
            return

        item = Nautilus.MenuItem(
            name="CompareWithMeldExtension::OpenMeld",
            label=label,
            tip="Compare selected items using Meld",
            icon="meld"
        )

        item.connect("activate", self._open_meld, files)
        return [item]
