#    ____        __     
#   / __ \__  __/ /____ 
#  / / / / / / / __/ _ \
# / /_/ / /_/ / /_/  __/
# \___\_\__,_/\__/\___/
#

config.load_autoconfig(False)

# Search engines and default pages
config.set('url.start_pages', ['https://duckduckgo.com/'])
config.set('url.default_page', 'https://duckduckgo.com/')
config.set('url.searchengines', {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'gg': 'https://www.google.com/search?q={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}',
})

# Preferences
config.set('fonts.default_size', '12pt')
config.set('colors.webpage.darkmode.enabled', True) # Permanent Dark Mode
config.set('content.blocking.method', 'both')      # Better Ad-blocking
c.auto_save.session = True
c.session.lazy_restore = True

c.fonts.default_family = "JetBrainsMono Nerd Font"
c.fonts.web.family.standard = "" # Leave empty to let the site decide
c.fonts.web.family.sans_serif = "JetBrainsMono Nerd Font"
c.fonts.web.family.fixed = "JetBrainsMono Nerd Font"
c.colors.webpage.preferred_color_scheme = 'dark'
c.qt.args = ['enable-gpu-rasterization', 'ignore-gpu-blocklist']

c.colors.tabs.even.bg = "#1C1C1E"
c.colors.tabs.odd.bg = "#1C1C1E"
c.colors.tabs.selected.even.bg = "#2C2C2E"
c.colors.tabs.selected.odd.bg = "#2C2C2E"
c.colors.statusbar.normal.bg = "#1C1C1E"

# Binds
config.bind('<Ctrl-t>', 'cmd-set-text -s :open -t', mode='normal')
config.bind('<Ctrl-Shift-t>', 'undo', mode='normal')
config.bind('<Alt-r>', 'config-source')
config.bind('<Alt-d>', 'config-cycle colors.webpage.darkmode.enabled true false')

# Aliases
c.aliases = {
    'q': 'close',
    'tq': 'tab-close',
    'o': 'cmd-set-text -s :open',
    'tab-new': 'open -t',
    'gh': 'open -t github.com',
    'confs': 'config-source',
    'dark': 'set colors.webpage.darkmode.enabled true',
    'light': 'set colors.webpage.darkmode.enabled false'
}
# AD-blocking
# c.content.host_blocking.enabled = True
# c.content.host_blocking.lists = [
#     'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
# ]

# Errors occurred while reading config.py: 
# autoconfig loading not specified: Your config.py should call either `config.load_autoconfig()` (to load settings configured via the GUI) or `config.load_autoconfig(False)` (to not do so) 
