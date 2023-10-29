#! /usr/bin/env -S python3 -B

"""
Dump a selection of Pelican settings in a format that GitHub
Actions output understands.

Author: Christopher O'Brien <obriencj@gmail.com>
License: MIT
"""


from os import environ
from pelican import DEFAULT_CONFIG_NAME, main, parse_arguments
from pelican.settings import get_settings_from_file
from shlex import quote


# we're expecting this file to be provided as a volume mount when
# invoked as an action. If it's not mounted, then we'll just create it
# and it can be ignored.
GITHUB_OUTPUT = "/pelican/github_output"


def get_settings(argv):
    """
    Load settings in a manner similar to pelican, but without
    expanding to absolute paths, and without erroring out if theme
    isn't found. We just want to get the settings, not act on them.
    """

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


def entrypoint(argv):
    """
    Fetch and record the settings, then invoke pelican. This is
    essentially just a thin wrapper to make sure we can get our
    computed settings recorded for the github action output.
    """

    settings = get_settings(argv)

    wanted = (
        'SETTINGS', 'PATH', 'OUTPUT_PATH',
        'THEME', 'SITEURL', 'SITENAME', 'SITESUBTITLE',
    )

    gho = environ.get("GITHUB_OUTPUT", GITHUB_OUTPUT)
    with open(gho, "at") as out:
        for key in wanted:
            print(f'{key}={quote(settings.get(key))}', file=out)

    return main(argv) or 0


if __name__ == '__main__':
    import sys
    sys.argv[0] = "pelican"  # lie a little
    sys.exit(entrypoint(sys.argv[1:]))


# The end.
