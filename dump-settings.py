#! /usr/bin/env -S python3 -B

"""
Dump a selection of Pelican settings in a format that GitHub
Actions output understands.

Author: Christopher O'Brien <obriencj@gmail.com>
License: MIT
"""


from pelican import DEFAULT_CONFIG_NAME, parse_arguments
from pelican.settings import get_settings_from_file
from shlex import quote


def get_settings(argv):
    args = parse_arguments(argv)
    conf = args.settings

    if not conf:
        conf = args.settings = DEFAULT_CONFIG_NAME

    settings = get_settings_from_file(conf)
    settings['SETTINGS'] = conf

    override = (
        ('path', 'PATH'),
        ('output', 'OUTPUT_PATH'),
        ('theme', 'THEME'),
    )

    for attr, key in override:
        val = getattr(args, attr, None)
        if val:
            settings[key] = val

    return settings


def main(argv):
    settings = get_settings(argv)

    wanted = (
        'SETTINGS', 'PATH', 'OUTPUT_PATH',
        'THEME', 'SITEURL', 'SITENAME', 'SITESUBTITLE',
    )

    for key in wanted:
        print(f'{key}={quote(settings.get(key))}')


if __name__ == '__main__':
    import sys
    main(sys.argv[1:])


# The end.
