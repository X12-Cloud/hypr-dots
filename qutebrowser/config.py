#    ____        __     
#   / __ \__  __/ /____ 
#  / / / / / / / __/ _ \
# / /_/ / /_/ / /_/  __/
# \___\_\__,_/\__/\___/
#

#Search engines and default pages
config.set('url.start_pages', ['https://duckduckgo.com/'])
config.set('url.default_page', 'https://duckduckgo.com/')
config.set('url.searchengines', {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'gg': 'https://www.google.com/search?q={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}', # Arch Wiki
})

# Prefrences
config.set('fonts.default_size', '12pt')

# Binds
config.bind('<Ctrl-t>', 'cmd-set-text -s :open -t', mode='normal')
config.bind('<Ctrl-Shift-t', 'undo', mode='normal')
config.bind('<Ctrl-Shift-r>', 'config-source')

# Aliases
c.aliases = {
    'q': 'close',
    'tq': 'tab-close',
    'o': 'cmd-set-text -s :open',
    'tab-new': 'open -t',
    'tab-c': 'open',
    'confs': 'config-source',

    # Websites
    'gh': 'open -t github.com'
}

# AD-blocking
# c.content.host_blocking.enabled = True
# c.content.host_blocking.lists = [
#     'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
# ]

