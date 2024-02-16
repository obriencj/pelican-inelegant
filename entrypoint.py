#! /usr/bin/env python3

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
# and it can be ignored. Note that this is only the default value,
# we'll be checking for a GITHUB_OUTPUT environment variable and
# honoring that if it is set.
GITHUB_OUTPUT = "/pelican/github_output"


def get_settings(argv):
    # Load settings in a manner similar to pelican, but without
    # expanding to absolute paths, and without erroring out if theme
    # isn't found. We just want to get the settings, not act on them.

    args = parse_arguments(argv)
    conf = args.settings or DEFAULT_CONFIG_NAME

    # load the settings directly from the configuration file (or error
    # out if one doesn't exist). We'll also include the settings
    # filename itself as an artificial setting.
    settings = get_settings_from_file(conf)
    settings['SETTINGS'] = conf

    # these attributes of the args will be applied as overriding
    # settings values if they are provided. Under a full pelican
    # invocation there are more overrides, but these are the only ones
    # we care about reporting back into the GITHUB_OUTPUT.
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


def record_settings(settings):
    # we're only interested in a small selection of the settings
    # values
    wanted = (
        'SETTINGS', 'PATH', 'OUTPUT_PATH',
        'THEME', 'SITEURL', 'SITENAME', 'SITESUBTITLE',
    )

    # emit those values into the appropriate file
    gho = environ.get("GITHUB_OUTPUT", GITHUB_OUTPUT)
    with open(gho, "at") as out:
        for key in wanted:
            print(f'{key}={quote(settings.get(key))}', file=out)


def entrypoint(argv):
    # essentially just a thin wrapper to make sure we can get our
    # computed settings recorded for the github action output.

    # load settings and record some of them to file
    record_settings(get_settings(argv))

    # then actually invoke pelican with the same arguments and let it
    # do its thing
    try:
        return main(argv) or 0

    except KeyboardInterrupt:
        print("Interrupted")
        return 130


if __name__ == '__main__':
    import sys
    sys.argv[0] = "pelican"  # lie a little
    sys.exit(entrypoint(sys.argv[1:]))


# The end.
