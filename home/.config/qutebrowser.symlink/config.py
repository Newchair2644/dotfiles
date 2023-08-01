from os import environ
from subprocess import run

# Autoconfig Default Settings
config.load_autoconfig()
config.source("theme.py")

# Search Engines
#spawn --userscript ripbang a archlinux aur aw e nintendo nintendowiki o osm reddit reddits s so voiddocs wiki yt
#c.url.searchengines["!piped"] = "https://www.watch.whatever.social/search?q={}"
config.bind('!', 'set-cmd-text :open -t -r !')

# Pass integration
config.bind('<Alt-Shift-u>', 'spawn --userscript /usr/share/qutebrowser/userscripts/password_fill', mode='insert')
config.bind('pw', 'spawn --userscript /usr/share/qutebrowser/userscripts/password_fill', mode='normal')

# Env vars
TERMINAL = environ['TERMINAL']
EDITOR = environ['EDITOR']

# Bindings for normal mode
config.bind("cm", "clear-messages")
config.bind("M", "bookmark-add --toggle")
config.bind(";I", "hint images spawn sh -c \"curl '{hint-url}' --output - | swayimg -\"")
config.bind(",v", "spawn --userscript view_in_mpv {url}")
config.bind(";v", "hint links spawn mpv {hint-url}")
config.bind(",m", "spawn mpd_queue_yt {url}")
config.bind(";m", "hint links spawn mpd_queue_yt {hint-url}")
config.bind(";m", "hint links spawn mpd_queue_yt {hint-url}")
config.bind(";p", "hint links spawn echo {hint-url} > \"%s/.config/qutebrowser/bookmarks/read-it-later\"" % (environ['HOME']))
config.bind("<Ctrl+o>", "back")
config.bind("<Ctrl+i>", "forward")
config.bind("gk", "scroll-to-perc 0")
config.bind("gj", "scroll-to-perc 100")

#yt_dl_cmd = "youtube-dl --add-metadata -i"
#config.bind(",z", "spawn %s -e %s {url}" % (TERMINAL, yt_dl_cmd))
#config.bind(",Z", "hint links spawn alacritty -e %s {hint-url}" % yt_dl_cmd)
config.bind("ta", "config-cycle statusbar.show always never;; config-cycle tabs.show always never")
config.bind("tb", "config-cycle statusbar.show always never")
config.bind("tt", "config-cycle tabs.show always never")

# ADP Blocking lists
c.content.blocking.adblock.lists = [
	"https://fanboy.co.nz/r/fanboy-ultimate.txt"
	"https://fanboy.co.nz/fanboy-annoyance.txt"
	"https://fanboy.co.nz/fanboy-antifacebook.txt"
	"https://fanboy.co.nz/fanboy-cookiemonster.txt"
	"https://easylist.to/easylist/easylist.txt"
	"https://easylist.to/easylist/easyprivacy.txt"
	"https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
	"https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
	"https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
	"https://github.com/DandelionSprout/adfilt/raw/master/AnnoyancesList"
	"https://github.com/DandelionSprout/adfilt/raw/master/SocialShareList.txt"
	"https://github.com/DandelionSprout/adfilt/raw/master/ExtremelyCondensedList.txt"
]

# Set defaults
c.downloads.location.directory = run(['xdg-user-dir', 'DOWNLOAD'], capture_output=True, text=True).stdout[:-1]
c.editor.command = ["foot", "nvim", "{file}"]
c.session.lazy_restore = True
c.content.autoplay = False

c.tabs.show = "always"
c.tabs.select_on_remove = "last-used"
c.tabs.position = "top"
c.fonts.default_family = "monospace"
c.fonts.default_size = "10pt"
c.fileselect.handler = "external"

file_picker = ["foot", "-T", "File Picker", "-e", "nnn", "-p", "{}"]
c.fileselect.handler = "external"
c.fileselect.single_file.command = file_picker
c.fileselect.multiple_files.command = file_picker
c.fileselect.folder.command = file_picker

# Prefer dark mode
c.colors.webpage.preferred_color_scheme = "auto"
